require_relative 'repository'
require_relative 'scene'
require_relative 'room'
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

      def retrieve(id)
        result = Items::Repository.retrieve(id)
        result.serialize
      end

      def retrieve_by_parent(id)
        children = Items::Repository.retrieve_by_parent(id)
        children.map! do |item|
          {
            id: item.id,
            name: item.name,
            type: item.type,
            number: item.number,
            children: Items::Service.retrieve_by_parent(item.id)
          }
        end
        children
      end
    end
  end
end
