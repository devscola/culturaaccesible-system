require 'mongo'
require_relative '../../support/configuration'

module Exhibitions
  class Repository
    @content = []

    class << self
      def store(exhibition_data)
        exhibition = Exhibitions::Exhibition.new(exhibition_data)
        @content << exhibition
        exhibition
      end

      def retrieve(name)
        @content ||= []
        result = @content.find { |exhibition| exhibition.name == name }
        result
      end

      def all
        @content
      end

      def flush
        @content = []
      end
    end
  end
end
