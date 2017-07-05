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

      def retrieve_for_list(id)
        exhibition = Exhibitions::Repository.retrieve(id)
        children = Items::Service.retrieve_by_exhibition(id)
        children.map! do |item|
          type = item[:author] === '' ? 'room' : 'item'
          { id: item[:id], name: item[:name], type: type }
        end
        { name: exhibition.name, :children => children }
      end

      def list
        list = Exhibitions::Repository.all
        list.map { |exhibition| exhibition.serialize }
      end

      def flush
        Exhibitions::Repository.flush
      end

      def add_number(exhibition_id, number)
        Exhibitions::Repository.add_number(exhibition_id, number)
      end

    end
  end
end
