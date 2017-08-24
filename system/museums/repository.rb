require 'mongo'
require_relative '../commons/connection'

module Museums
  class Repository
    @content = []

    class << self

      def connection
          Database::Connection.get_connection
      end

      def store(museum_data)
        museum = Museums::Museum.new(museum_data)
        connection.museums.insert_one(museum.serialize)
        connection.close
        museum
      end

      def update(museum_data)
        museum = Museums::Museum.new(museum_data, museum_data['id'])
        document = museum.serialize
        updated_museum_data = connection.museums.find_one_and_update({ id: document[:id] }, document, {:return_document => :after })
        Museums::Museum.from_bson(updated_museum_data, updated_museum_data['id'])
      end

      def retrieve(id)
          data = connection.museums.find({ id: id }).first
          museum = Museums::Museum.from_bson(data, data['id'])
          connection.close
          museum
      end

      def all
        museums_data = connection.museums.find()
        museums_data.map { |data| Museums::Museum.from_bson(data, data['id']) }
      end

      def flush
        connection.museums.delete_many
      end
    end
  end
end
