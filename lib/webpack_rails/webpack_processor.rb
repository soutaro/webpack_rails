require 'set'

module WebpackRails
  module WebpackProcessor
    mattr_accessor :port
    mattr_accessor :pid
    mattr_accessor :entries

    def self.cache_key
      # This disables sprockets caching
      "webpack" + SecureRandom.hex(8)
    end

    def self.call(input)
      if needs_webpack?(input)
        run_webpack(input)
      else
        input[:data]
      end
    end

    def self.prepare(app)
      self.pid ||= Server.ensure_started(app.config.webpack_rails)
      self.port ||= app.config.webpack_rails.port
      self.entries = Set.new(app.config.webpack_rails[:entries])
    end

    def self.needs_webpack?(input)
      module_name = Config.module_name(Pathname(input[:filename]).basename)
      entries.include?(module_name)
    end

    def self.run_webpack(input)
      module_name = Config.module_name(Pathname(input[:filename]))

      File.atomic_write(Server.input_dir + module_name) do |io|
        io.write(input[:data])
      end

      res = Net::HTTP.start('localhost', port) {|http| http.get("/" + module_name) }
      res.body
    end

    at_exit do
      Server.teardown
    end
  end
end

