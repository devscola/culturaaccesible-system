require_relative '../../support/configuration'


module Database
  class Connection

    def initialize
      @connection ||= Mongo::Client.new(
        ["#{host}:27017"],
        :database => 'cuac-system_db'
      )
    end

    def close
      @connection.close
    end

    def museums
      @connection[:museums]
    end

    private

    def host
      Support::Configuration.host
    end

  end

end
