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
        item = create_item( data )
        item
      end

      def merge_translation(id, iso_code='es')
        data = connection.items.find({id: id}).first
        item = create_item( data ).serialize
        item_translation = connection.item_translations.find({item_id: id, iso_code: iso_code}).first
        translated_item = Items::Translation.from_bson(item_translation, id , item_translation['item_id']).serialize
        item.each do |key, value|
          item[key] = translated_item[key] if translated_item[key]
        end
        item
      end

      def retrieve_translations(item_id)
        item_translations = connection.item_translations.find({item_id: item_id})
        item_translations.map { |data| Items::Translation.from_bson(data, item_id, data['id']).serialize }
      end

      def retrieve_by_parent(parent_id)
        retrieved = []
        items_data = connection.items.find({ parent_id: parent_id })
        connection.close
        items_data.each do |data|
          item = create_item( data ).serialize
          retrieved << item
        end
        retrieved
      end

      def store_translation(data, item_id)
        translation_item = Items::Translation.new(data, item_id)
        connection.item_translations.insert_one(translation_item.serialize)
        translation_item
      end

      def update_translation(data, item_id)
        translation_item = Items::Translation.new(data, item_id, data['id'])
        translation_item = connection.item_translations.find_one_and_update({ id: data['id'] }, { "$set" => translation_item.serialize }, {:return_document => :after })
        Items::Translation.from_bson(translation_item, item_id, translation_item['id'])
      end

      def flush
        connection.items.delete_many
        connection.item_translations.delete_many
        connection.close
      end

      private

      def update(item_data, type)
        updated_item = connection.items.find_one_and_update({ id: item_data['id'] }, item_data, {:return_document => :after })
        item = type == 'scene' ? Items::Scene.new(updated_item, updated_item['id']) : Items::Room.new(updated_item, updated_item['id'])
        item
      end

      def store(item_data, type)
        item = type == 'scene' ? Items::Scene.new(item_data) : Items::Room.new(item_data)
        connection.items.insert_one(item.serialize)
        connection.close
        item
      end

      def create_item(data)
        data['type'] == 'scene' ? Items::Scene.from_bson(data, data['id']) : Items::Room.from_bson(data, data['id'])
      end

    end
  end
end
