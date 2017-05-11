require 'mongo'
require_relative '../../support/configuration'

module Exhibitions
  class Repository
    class << self
      def store(exhibition_data)
        @content ||= []
        exhibition = Exhibitions::Exhibition.new(exhibition_data)
        @content << exhibition
        exhibition
      end

      def retrieve(id)
        @content ||= []
        result = @content.find { |exhibition| exhibition.id == id }
        result
      end

      def all
        @content
      end

      def flush
        @content = []
      end

      def connection
        @connection ||= Mongo::Client.new(
          ["#{host}:27017"],
          :database => 'cuac_db'
        )
      end

      def host
        Support::Configuration.host
      end
    end
  end
end
