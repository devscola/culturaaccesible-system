module Rooms
  class Repository
    @content = []

    class << self

      def choose_action(room_data)
        id = room_data['id']
        if (id)
          result = update(room_data)
        else
          result = store(room_data)
        end
      end

      def retrieve(id)
        @content ||= []
        result = @content.find { |item| item.id == id }
        result
      end

      def flush
        @content = []
      end

      private

      def update(room_data)
        id =  room_data['id']
        room = Rooms::Room.new(room_data, id)

        current_room = @content.find { |element| element.id == room.id }
        current_room
      end

      def store(room_data)
        Exhibitions::Service.add_number(room_data['exhibition_id'], room_data['number'])
        room = Rooms::Room.new(room_data)
        @content << room
        room
      end

    end
  end
end
