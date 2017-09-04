require 'mongo'
require_relative '../commons/connection'

module Items
  class Repository

    class << self

      def connection
          Database::Connection.get_connection
      end

      def choose_action(item_data, type='scene')
        id = item_data['id']
        if (id != '')
          result = update(item_data, type)
        else
          result = store(item_data, type)
        end
      end

      def retrieve(id)
        data = connection.items.find({ id: id }).first
        connection.close
        item = (data[:type] == 'scene') ? Items::Scene.from_bson(data, data['id']) : Items::Room.from_bson(data, data['id'])
        item
      end

      def merge_translation(id, iso_code='en')
        connection.item_translations.insert_one({id: id, description: 'en castellano', video: 'k', iso_code: 'es'})
        connection.item_translations.insert_one({id: id, description: 'in English', video: 'k', iso_code: 'es'})

        item = connection.items.find({id: id}, {:return_document => :after })
        item_translation = connection.item_translations.find({id: id}, {:return_document => :after })
        item.each do |key, value|
          item[key] = item_translation[key] if item_translation[key]
        end
        item
      end

      def retrieve_by_parent(parent_id)
        retrieved = []
        items_data = connection.items.find({ parent_id: parent_id })
        connection.close
        items_data.each do |data|
          item = data['type'] == 'scene' ? Items::Scene.from_bson(data, data['id']).serialize : Items::Room.from_bson(data, data['id']).serialize
          retrieved << item
        end
        retrieved
      end

      def flush
        connection.items.delete_many
        connection.close
      end

      private

      def update(item_data, type)
        updated_item = connection.items.find_one_and_update({ id: item_data['id'] }, item_data, {:return_document => :after })
        connection.close
        item = type == 'scene' ? Items::Scene.new(updated_item, updated_item['id']) : Items::Room.new(updated_item, updated_item['id'])
        item
      end

      def store(item_data, type)
        item = type == 'scene' ? Items::Scene.new(item_data) : Items::Room.new(item_data)
        connection.items.insert_one(item.serialize)
        connection.close
        item
      end

    end
  end
end
