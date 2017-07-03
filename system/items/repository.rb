module Items
  class Repository
    @content = []

    class << self
      def choose_action(item_data)
        id = item_data['id']
        if (id)
          result = update(item_data)
        else
          result = store(item_data)
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

      def update(item_data)
        id =  item_data['id']
        item = Items::Item.new(item_data, id)

        current_item = @content.find { |element| element.id == item.id }
        current_item
      end

      def store(item_data)
        Exhibitions::Service.add_number(item_data['exhibition_id'], item_data['number'])
        item = Items::Item.new(item_data)
        @content << item
        item
      end

    end
  end
end
