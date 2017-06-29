module Items
  class Repository
    @content = []

    class << self
      def store(item_data)
        Exhibitions::Service.add_number(item_data['exhibition_id'], item_data['number'])
        item = Items::Item.new(item_data)
        @content << item
        item
      end
    end
  end
end
