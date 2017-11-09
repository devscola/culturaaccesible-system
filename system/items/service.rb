require_relative 'repository'
require_relative 'scene'
require_relative 'room'
require_relative 'translation'
require_relative '../exhibitions/service'

module Items
  class Service
    class << self
      def store_scene(scene_data)
        if (scene_data['type'] == 'scene')
          result = Items::Repository.choose_action(scene_data)
          result.serialize
        else
          raise ArgumentError, 'Updating room not allows changing it to scene'
        end
      end

      def store_room(room_data)
        if ((room_data['parent_class'] == 'exhibition') && (room_data['room'] == true) && (room_data['type'] == 'room'))
          result = Items::Repository.choose_action(room_data, 'room')
          result.serialize
        else
          raise ArgumentError, 'Store or update item error'
        end
      end

      def store_translations(data_translations, item_id)
        data_translations.map! { |item| Items::Repository.store_translation(item, item_id).serialize }
      end

      def retrieve_translations(item_id)
        Items::Repository.retrieve_translations(item_id)
      end

      def retrieve(id)
        result = Items::Repository.retrieve(id)
        result.serialize
      end

      def merge_translation(id, iso_code='es')
        Items::Repository.merge_translation(id, iso_code)
      end

      def retrieve_by_parent(id, order, iso_code = nil)
        children = Items::Repository.retrieve_by_parent(id)
        list = []
        children.each do |item|
          item = Items::Repository.merge_translation( item[:id], iso_code ) if iso_code
          next unless order.serialize[:index].value?(item[:id])
          item_list = {
            id: item[:id],
            name: item[:name],
            type: item[:type],
            beacon: item[:beacon],
            author: item[:author] || '',
            date: item[:date] || '',
            image: item[:image] || '',
            video: item[:video] || '',
            description: item[:description],
            number: order.retrieve_ordinal(item[:id]),
            children: Items::Service.retrieve_by_parent(item[:id], order, iso_code)
          }
          list << item_list
        end
        children_list = sorted_list(list)
        children_list
      end

      def sorted_list(children)
        children.sort_by { |child| child[:number] }
      end

      def retrieve_childrens(parent_id)
        Items::Repository.retrieve_by_parent(parent_id)
      end

      def update_translations(translations, item_id)
        translations.map! { |item| Items::Repository.update_translation(item, item_id).serialize }
      end

      def flush
        Items::Repository.flush
      end

    end
  end
end
