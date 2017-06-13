require_relative 'repository'
require_relative 'exhibition'

module Exhibitions
  class Service
    class << self
      def store(exhibition_data)
        exhibition = Exhibitions::Repository.store(exhibition_data)
        exhibition.serialize
      end

      def retrieve(name)
        exhibition = Exhibitions::Repository.retrieve(name)
        exhibition.serialize
      end

      def list
        list = Exhibitions::Repository.all
        list.map { |exhibition| exhibition.serialize }
      end
    end
  end
end
