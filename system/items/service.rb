require_relative 'repository'
require_relative 'item'
require_relative '../exhibitions/service'
require_relative '../rooms/repository'
require_relative '../rooms/room'

module Items
  class Service
    class << self
      def store_item(item_data)
        result = Items::Repository.choose_action(item_data)
        result.serialize
      end

      def store_room(room_data)
        result = Rooms::Repository.choose_action(room_data)
        result.serialize
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
