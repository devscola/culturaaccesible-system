require 'digest/md5'
require_relative 'repository'
require_relative 'exhibition'

module Exhibitions
  class Service
    class << self
      def store(exhibition_data)
        exhibition = Exhibitions::Repository.store(exhibition_data)
        exhibition.serialize
      end

      def retrieve(id)
        exhibition = Exhibitions::Repository.retrieve(id)
        exhibition.serialize
      end

      def update(exhibition_data)
        id = exhibition_data['id']
        exhibition = Exhibitions::Exhibition.new(exhibition_data, id)
        updated_exhibition = Exhibitions::Repository.update(exhibition)
        updated_exhibition.serialize
      end

      def list
        list = Exhibitions::Repository.all
        list.map { |exhibition| exhibition.serialize }
      end
    end
  end
end
