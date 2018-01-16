require_relative '../../support/configuration'


module Database
  class Connection
    class << self

      def get_connection
        @connection ||= Mongo::Client.new(
          ["#{host}:27017"],
          :database => 'cuac-system_db'
        )
        self
      end

      def close
        # @connection.close
      end

      def museums
        @connection[:museums]
      end

      def exhibitions
        @connection[:exhibitions]
      end

      def items
        @connection[:items]
      end

      def item_translations
        @connection[:item_translations]
      end

      def exhibition_translations
        @connection[:exhibition_translations]
      end

      def museum_translations
        @connection[:museum_translations]
      end

      private

      def host
        Support::Configuration.host
      end
    end
  end
end
