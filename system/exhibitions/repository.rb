require 'mongo'
require_relative '../commons/connection'

module Exhibitions
  class Repository

    class << self

      def connection
          Database::Connection.get_connection
      end

      def choose_action(exhibition_data)
        id = exhibition_data['id']
        if (id)
          result = update(exhibition_data)
        else
          result = store(exhibition_data)
        end
      end

      def translation_choose_action(data_translation, exhibition_id)
        data_translation.map! do |data|
          id = data['id']
          if (id)
            update_translation(data)
          else
            store_translation(data, exhibition_id)
          end
        end
        data_translation
      end

      def retrieve(id)
        data = connection.exhibitions.find({ id: id }).first
        exhibition = Exhibitions::Exhibition.from_bson(data, data['id'], data['order'])
        connection.close
        exhibition
      end

      def retrieve_translated(id, iso_code)
        data = connection.exhibitions.find({id: id}).first
        exhibition = Exhibition.from_bson(data, data['id'], data['order']).serialize
        exhibition_translation = connection.exhibition_translations.find({exhibition_id: id, iso_code: iso_code}).first
        translated_exhibition = Exhibitions::Translation.from_bson(exhibition_translation, exhibition_translation['exhibition_id'], id).serialize
        exhibition.each do |key, value|
          exhibition[key] = translated_exhibition[key] if translated_exhibition[key]
        end
        exhibition
      end

      def retrieve_translations(exhibition_id)
        exhibition_translations = connection.exhibition_translations.find({exhibition_id: exhibition_id})

        translations =  []
        exhibition_translations.map do |translation|
          translations.push(Exhibitions::Translation.from_bson(translation, exhibition_id, translation['id']).serialize)
        end
        translations
      end

      def delete(id)
        exhibition = retrieve(id)
        exhibition.deleted = true
        exhibition = update_exhibition(exhibition)
      end

      def all
        exhibitions_data = connection.exhibitions.find({}, :fields => ['id', 'name', 'show'])
        exhibitions_data.map { |data| Exhibitions::Exhibition.from_bson(data, data['id'], data['order']).serialize}
        exhibitions_data.select { |exhibition| exhibition[:deleted] == false }
      end

      def retrieve_next_ordinal(exhibition_id, ordinal)
        exhibition = retrieve(exhibition_id)
        exhibition.order.next_child(ordinal)
      end

      def flush
        connection.exhibitions.delete_many
      end

      def update_exhibition(exhibition)
        document = exhibition.serialize
        begin
          updated_exhibition = connection.exhibitions.find_one_and_update({ id: document[:id] }, document, {:return_document => :after })
          Exhibitions::Exhibition.from_bson(updated_exhibition, updated_exhibition['id'], exhibition.order.serialize)
        rescue => error
          p error
          p document
        end
      end

      def store_translation(data, exhibition_id)
        translation_exhibition = Exhibitions::Translation.new(data, exhibition_id)
        connection.exhibition_translations.insert_one(translation_exhibition.serialize)
        translation_exhibition.serialize
      end

      private

      def update(exhibition_data)
        id =  exhibition_data['id']
        exhibition = retrieve(id)
        updated_exhibition = Exhibitions::Exhibition.new(exhibition_data, id, exhibition.order)
        update_exhibition(updated_exhibition)
      end

      def update_translation(translation)
        updated_translation = connection.exhibition_translations.find_one_and_update({ id: translation['id'] }, { "$set" => translation }, {:return_document => :after })
        Exhibitions::Translation.from_bson(updated_translation, updated_translation['exhibition_id'], updated_translation['id']).serialize
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
