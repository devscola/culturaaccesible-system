require_relative 'repository'
require_relative 'museum'

module Museums
  class Service
    class << self
      def store(museum_data)
        museum = Museums::Repository.store(museum_data)
        museum.serialize
      end

      def retrieve(name)
        museum = Museums::Repository.retrieve(name)
        museum.serialize
      end

      def list
        list = Museums::Repository.all
        list.map { |museum| museum.serialize }
      end

      def flush
        Museums::Repository.flush
      end
    end
  end
end
