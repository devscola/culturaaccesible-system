module Items
  class Repository
    @content = []
    @relation = []

    class << self
      def choose_action(item_data, type='scene')
        id = item_data['id']
        if (id != '')
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

      def retrieve_relation(order, id)
        @relation ||= []
        result = @relation.find { |item| item.get_order == order && item.get_exhibition_id == id}
        result
      end

      def retrieve_by_parent(id)
        result = @content.select { |item| item.parent_id == id }
        result
      end

      def flush
        @content = []
      end

      private

      def update(item_data, type)
        id =  item_data['id']
        exhibition_id = item_data['exhibition_id']
        last_item = retrieve(id)
        index = @content.index(last_item)
        updated_item = type == 'scene' ? Items::Scene.new(item_data, exhibition_id, id ) : Items::Room.new(item_data, id)

        Exhibitions::Service.add_number(exhibition_id, item_data['number'], item_data['last_number'])

        @content[index] = updated_item
        @content[index]
      end

      def store(item_data, type)
        exhibition_id = item_data['exhibition_id']
        item = type == 'scene' ? Items::Scene.new(item_data, exhibition_id) : Items::Room.new(item_data)
        Exhibitions::Service.add_number(exhibition_id, item_data['number'])
        @relation << item.relation
        @content << item
        item
      end

    end
  end
end
