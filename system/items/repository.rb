module Items
  class Repository
    @content = []

    class << self
      def store(item_data)
        item = Items::Item.new(item_data)
        @content << item
        item
      end
    end
  end
end
