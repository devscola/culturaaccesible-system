require 'digest/md5'
require_relative 'repository'
require_relative 'museum'
require_relative 'info'
require_relative 'location'
require_relative 'contact'
require_relative 'price'
require_relative 'schedule'
require_relative '../helpers/defense'

module Museums
  class Service
    class << self
      def store(museum_data)
        museum = Museums::Repository.store(museum_data)
        museum.serialize
      end

      def retrieve(id)
        museum = Museums::Repository.retrieve(id)
        museum.serialize
      end

      def update(museum_data)
        museum = Museums::Repository.update(museum_data)
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
