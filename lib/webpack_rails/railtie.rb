module WebpackRails
  class Railtie < Rails::Engine
    def self.find_webpack_bin
      bin = `which webpack`.chomp
      return Pathname(bin) if bin.present?

      Pathname(`npm prefix`) + "node_modules/webpack/bin/webpack.js"
    end

    config.webpack_rails = ActiveSupport::OrderedOptions.new

    config.webpack_rails.port = 29587
    config.webpack_rails.webpack_bin = find_webpack_bin
    config.webpack_rails.node_bin = Pathname(`which node`.chomp)
    config.webpack_rails.entries = ["application.js"]
    config.webpack_rails.config = nil
    config.webpack_rails.silent = true

    initializer :setup_webpack do |app|
      config_file = Rails.root + "config/webpack.json"
      file_config = if config_file.file?
                      JSON.load(config_file.read, symbolize_names: true)
                    else
                      {}
                    end
      app.config.webpack_rails.config = Config.merge(file_config, app.config.webpack_rails.config || {})

      app.assets.register_postprocessor "application/javascript", WebpackProcessor
      WebpackProcessor.prepare(app)
    end
  end
end
