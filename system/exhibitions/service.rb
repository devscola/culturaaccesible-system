require 'digest/md5'
require_relative 'repository'
require_relative 'exhibition'
require_relative 'order'
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

      def sort_list(children)
        children.sort_by { |child| child[:number] }
      end

      def retrieve_next_ordinal(exhibition_id, ordinal)
        next_child = Exhibitions::Repository.retrieve_next_ordinal(exhibition_id, ordinal)
        { next_child: next_child }
      end

      def list
        list = Exhibitions::Repository.all
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
