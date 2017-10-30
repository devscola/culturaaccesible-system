Mongo::Logger.logger.level = ::Logger::INFO

module Support
  class Configuration
    HOSTS = {
      'development' => 'mongo-cuac-container',
      'production'  => 'mongo-cuac-container',
      nil => 'localhost'
    }

    def self.retrieve_mode
      begin
        system_environment = ENV.fetch('SYSTEM_MODE')
      rescue
        system_environment = nil
      end
      return system_environment
    end

    def self.host
      HOSTS[retrieve_mode]
    end
  end
end
