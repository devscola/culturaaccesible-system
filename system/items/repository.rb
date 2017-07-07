module Items
  class Repository
    @content = []

    class << self
      def choose_action(item_data, type='scene')
        id = item_data['id']
        if (id)
          result = update(item_data, type)
        else
          result = store(item_data, type)
        end
      end

      def retrieve(id)
        @content ||= []
        result = @content.find { |item| item.id == id }
        result
      end

      def retrieve_by_exhibition(exhibition_id)
        result = @content.select { |item| item.parent_id == exhibition_id }
        result
      end

      def flush
        @content = []
      end

      private

      def update(item_data, type)
        id =  item_data['id']
        item = type == 'item' ? Items::Scene.new(item_data, id) : Items::Room.new(item_data, id)

        current_item = @content.find { |element| element.id == item.id }
        current_item
      end

      def store(item_data, type)
        Exhibitions::Service.add_number(item_data['exhibition_id'], item_data['number'])
        item = type == 'scene' ? Items::Scene.new(item_data) : Items::Room.new(item_data)
        @content << item
        item
      end

    end
  end
end
