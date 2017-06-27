require 'digest/md5'
require_relative 'repository'
require_relative 'exhibition'
require_relative '../helpers/defense'

module Exhibitions
  class Service
    class << self
      def store(exhibition_data)
        exhibition = Exhibitions::Repository.choose_action(exhibition_data)
        exhibition.serialize
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
