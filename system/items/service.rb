require_relative 'repository'
require_relative 'item'
require_relative 'room'
require_relative '../exhibitions/service'

module Items
  class Service
    class << self
      def store_item(item_data)
        result = Items::Repository.choose_action(item_data)
        result.serialize
      end

      def store_room(room_data)
        if ((room_data['parent_class'] == 'exhibition') && (room_data['room'] == true))
          result = Items::Repository.choose_action(room_data, 'room')
          result.serialize
        else
          raise ArgumentError, 'Creating rooms inside scenes or other rooms is not allowed'
        end
      end

      def retrieve(id)
        result = Items::Repository.retrieve(id)
        result.serialize
      end

      def retrieve_by_exhibition(exhibition_id)
        result = Items::Repository.retrieve_by_exhibition(exhibition_id)
        result.map! { |item| item.serialize }
        result
      end
    end
  end
end
