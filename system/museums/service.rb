require_relative 'repository'
require_relative 'museum'

module Museums
  class Service
    class << self

      def retrieve(id)
        museum = Museums::Repository.retrieve(id)
        museum.serialize
      end

      def store(museum_data)
        Museums::Repository.store(museum_data)
      end

      def flush
        Museums::Repository.flush
      end
    end
  end
end
