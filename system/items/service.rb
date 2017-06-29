require_relative 'repository'
require_relative 'item'
require_relative '../exhibitions/service'

module Items
  class Service
    class << self
      def store(item_data)
        result = Items::Repository.store(item_data)
        result.serialize
      end
    end
  end
end
