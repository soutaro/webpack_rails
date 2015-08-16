module WebpackRails
  module Server
    def self.ensure_started(config)
      ensure_dirs

      update_pid do |state|
        state[:clients] << Process.pid unless state[:clients].include?(Process.pid)
        state[:pid] ||= start_server(config)

        state[:pid]
      end
    end

    def self.teardown(force: false)
      ensure_dirs

      update_pid do |state|
        if state[:clients].include?(Process.pid)
          state[:clients].delete(Process.pid)
        end

        if force || (state[:clients].empty? && state[:pid])
          begin
            Process.kill "INT", state[:pid]
            Process.waitpid state[:pid]
          rescue Errno::ESRCH, Errno::ECHILD
            # ignore
          end

          state[:pid] = nil
          state[:clients] = []
        end
      end
    end

    def self.dir
      Rails.root + "tmp/webpack_rails"
    end

    def self.pid_file
      dir + "pid.json"
    end

    def self.lock_file
      dir + "lock"
    end

    def self.start_server(config)
      webpack_config = generate_config(config)

      config_js_path = dir + "webpack.config.js"

      config_js_path.write(<<EOJ)
module.exports = #{JSON.dump(webpack_config)};
EOJ

      command = [
        config.node_bin.to_s,
        (Pathname(__dir__) + "server.js").to_s,
        config.port.to_s,
        config_js_path.to_s,
        (!!config.silent).to_s
      ]

      env = {
        'NODE_PATH' => (Rails.root + "node_modules").to_s
      }

      Process.spawn(env, *command, chdir: Rails.root.to_s)
    end

    def self.generate_config(config)
      assets_path = Rails.root + "app/assets/javascripts"

      default = {
        devtool: "#inline-source-map",
        resolve: {
          root: [assets_path],
        },
        context: assets_path,
        entry: { },
        output: {
          path: dir + "output",
          filename: "[name].js"
        }
      }

      config[:entries].each do |file|
        path = Pathname(file)
        name = path.basename(path.extname)
        default[:entry][name] = "./" + path.to_s
      end

      if config.config.delete(:entry)
        Rails.logger.warn "[webpack_rails] entry definition in given webpack config is deleted"
      end

      Config.merge(default, config.config)
    end

    def self.ensure_dirs
      dir.mkpath
      (dir + "output").mkpath
    end

    def self.update_pid
      lock_file.open('w') do |io|
        io.flock(File::LOCK_EX)

        pid_file.write("") unless pid_file.file?

        content = pid_file.read

        state = if content.present?
                  JSON.load(content).deep_symbolize_keys
                else
                  {
                    pid: nil,
                    clients: []
                  }
                end

        result = yield(state)

        pid_file.write(JSON.dump(state))

        result
      end
    end
  end
end
