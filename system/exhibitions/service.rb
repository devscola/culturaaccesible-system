require 'digest/md5'
require_relative 'repository'
require_relative 'exhibition'
require_relative 'traslation'
require_relative 'order'
require_relative '../helpers/defense'

module Exhibitions
  class Service
    class << self
      def store(exhibition_data)
        exhibition = Exhibitions::Repository.choose_action(exhibition_data)
        exhibition.serialize
      end

      def delete(id)
        exhibition = Exhibitions::Repository.delete(id)
        exhibition.serialize
      end

      def retrieve(id)
        exhibition = Exhibitions::Repository.retrieve(id)
        exhibition.serialize
      end

      def retrieve_translated(id, iso_code)
        Exhibitions::Repository.retrieve_translated(id, iso_code)
      end

      def retrieve_translations(exhibition_id)
        Exhibitions::Repository.retrieve_translations(exhibition_id)
      end

      def sort_list(children)
        children.sort_by { |child| child[:number] }
      end

      def retrieve_next_ordinal(exhibition_id, ordinal)
        next_child = Exhibitions::Repository.retrieve_next_ordinal(exhibition_id, ordinal)
        { next_child: next_child }
      end

      def register_order(exhibition_id, item_id, ordinal)
        exhibition = Exhibitions::Repository.retrieve(exhibition_id)
        order = exhibition.order
        order.register(ordinal, item_id)
        Exhibitions::Repository.update_exhibition(exhibition)
      end

      def retrieve_ordinal(exhibition_id, item_id)
        exhibition = Exhibitions::Repository.retrieve(exhibition_id)
        order = exhibition.order
        order.retrieve_ordinal(item_id)
      end

      def store_translations(data_translations, exhibition_id)
        Exhibitions::Repository.translation_choose_action(data_translations, exhibition_id)
      end

      def list
        Exhibitions::Repository.all
      end

      def translated_list(iso_code)
        Exhibitions::Repository.all.map do |exhibition|
          retrieve_translated(exhibition['id'], iso_code)
        end
      end

      def flush
        Exhibitions::Repository.flush
      end
    end
  end
end
