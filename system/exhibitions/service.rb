require 'digest/md5'
require_relative 'repository'
require_relative 'exhibition'
require_relative '../helpers/defense'

module Exhibitions
  class Service
    class << self
      def store(exhibition_data)
        id = exhibition_data['id']
        if (id)
          result = Exhibitions::Repository.update(exhibition_data)
        else
          result = Exhibitions::Repository.store(exhibition_data)
        end
        result.serialize
      end

      def retrieve(id)
        exhibition = Exhibitions::Repository.retrieve(id)
        exhibition.serialize
      end

      def list
        list = Exhibitions::Repository.all
        list.map { |exhibition| exhibition.serialize }
      end

      def flush
        Exhibitions::Repository.flush
      end
    end
  end
end
