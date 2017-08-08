require 'mongo'
require_relative '../commons/connection'

module Exhibitions
  class Repository

    class << self

      def connection
          Database::Connection.new
      end

      def choose_action(exhibition_data)
        id = exhibition_data['id']
        if (id)
          result = update(exhibition_data)
        else
          result = store(exhibition_data)
        end
      end

      def retrieve(id)
        data = connection.exhibitions.find({ id: id }).first
        exhibition = Exhibitions::Exhibition.from_bson(data, data['id'], data['order'])
        connection.close
        exhibition
      end

      def all
        exhibitions_data = connection.exhibitions.find({}, :fields => ['id', 'name', 'show'])
        exhibitions_data.map{ |data| Exhibitions::Exhibition.from_bson(data, data['id'], data['order']).serialize}
      end

      def retrieve_next_ordinal(exhibition_id, ordinal)
        exhibition = retrieve(exhibition_id)
        exhibition.order.next_child(ordinal)
      end

      def flush
        connection.exhibitions.delete_many
      end

      def add_number(exhibition_id, number, last_number)
        exhibition = retrieve(exhibition_id)
        exhibition.set_numbers(number)

        if last_number != ''
          exhibition.remove_number(last_number)
        end

        update_exhibition(exhibition)

      end

      def update_exhibition(exhibition)
        document = exhibition.serialize
        updated_exhibition = connection.exhibitions.find_one_and_update({ id: document[:id] }, document, {:return_document => :after })

        Exhibitions::Exhibition.from_bson(updated_exhibition, updated_exhibition['id'], exhibition.order.serialize)
      end

      private

      def update(exhibition_data)
        id =  exhibition_data['id']

        exhibition = Exhibitions::Exhibition.new(exhibition_data, id)

        update_exhibition(exhibition)

      end

      def store(exhibition_data)
        exhibition = Exhibitions::Exhibition.new(exhibition_data)
        connection.exhibitions.insert_one(exhibition.serialize)
        connection.close
        exhibition
      end
    end
  end
end
