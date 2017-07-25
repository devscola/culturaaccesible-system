require 'digest/md5'
require_relative 'repository'
require_relative 'exhibition'
require_relative 'order'
require_relative '../items/repository'
require_relative '../items/relation'
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
        children = Items::Service.retrieve_by_parent(id)
        children.map! do |item|
          {
            id: item[:id],
            name: item[:name],
            type: item[:type],
            number: item[:number],
            children: Items::Service.retrieve_by_parent(item[:id])
          }
        end
        sorted_children = sorted_list(children)
        { id: exhibition.id, name: exhibition.name, :children => sorted_children }
      end

      def sorted_list(children)
        children.sort_by { |child| child[:number] }
      end

      def retrieve_next_ordinal(exhibition_id, ordinal)
        next_child = Exhibitions::Repository.retrieve_next_ordinal(exhibition_id, ordinal)
        { next_child: next_child }
      end

      def list
        Exhibitions::Repository.all
      end

      def flush
        Exhibitions::Repository.flush
      end

      def add_number(exhibition_id, number, last_number = '')
        Exhibitions::Repository.add_number(exhibition_id, number, last_number)
      end

    end
  end
end
