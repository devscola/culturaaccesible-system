require_relative 'repository'
require_relative 'item'

module Items
  class Service
    class << self
      def store(item_data)
        item = Items::Item.new(item_data)
        result = Items::Repository.store(item)
        result.serialize
      end
    end
  end
end