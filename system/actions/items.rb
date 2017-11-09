module Actions
  class Item
    class << self
      def add( data )
        exist = ensure_new_item_number( data['exhibition_id'], data['number'] )
        return exist if exist.class == RuntimeError
        return add_scene( data ) if data['room'] == false
        return add_room( data ) if data['room'] == true
      end

      def update( data )
        return update_scene( data ) if data['room'] == false
        return update_room( data ) if data['room'] == true
      end

      def retrieve( exhibition_id, item_id )
        result = retrieve_item( item_id )
        item_id = result[:id]
        result['translations'] = retrieve_translations( item_id )
        message_exception = 'Item not found'
        result = manage_exception(message_exception) do
          ordinal = Exhibitions::Service.retrieve_ordinal(exhibition_id, item_id)
          result['number'] = ordinal
          result
        end
      end

      private

      def ensure_new_item_number( exhibition_id, number )
        message_exception = 'Store or update item number error, number allready exist'
        result = manage_exception( message_exception ) do
          exhibition = Exhibitions::Service.retrieve( exhibition_id )
          numbers = exhibition[:order][:index].keys || []
          raise message_exception if numbers.include? number
        end
        result
      end

      def add_scene( data )
        number = data['number']
        result = store_scene( data )
        item_id = result[:id]
        register_order( data['exhibition_id'], item_id, number )
        result['translations'] = store_translations( data['translations'], item_id )
        result
      end

      def add_room( data )
        message_exception = 'Store or update item error'
        result = manage_exception(message_exception) do
          number = data['number']
          result = store_room( data )
          item_id = result[:id]
          register_order( data['exhibition_id'], item_id, number )
          result['translations'] = store_translations( data['translations'], item_id )
          result
        end
      end

      def update_scene( data )
        message_exception = 'Updating room not allows changing it to scene'
        result = manage_exception( message_exception ) do
          number = data['number']
          last_number = data['last_number']
          result = store_scene(data)
          item_id = result[:id]
          update_order( data['exhibition_id'], item_id, number, last_number )
          result['translations'] = update_translations( data['translations'], item_id )
          result
        end
      end

      def update_room( data )
        message_exception = 'Updating scene not allows changing it to room'
        result = manage_exception(message_exception) do
          number = data['number']
          last_number = data['last_number']
          result = store_room( data )
          item_id = result[:id]
          update_order( data['exhibition_id'], item_id, number, last_number )
          result['translations'] = update_translations( data['translations'], item_id )
          result
        end
      end

      def retrieve_item( item_id )
        Items::Service.retrieve( item_id )
      end

      def retrieve_translations( item_id )
        Items::Service.retrieve_translations( item_id )
      end

      def store_scene(data)
        Items::Service.store_scene( data )
      end

      def store_room(data)
        Items::Service.store_room( data )
      end

      def register_order( exhibition_id, item_id, number )
        Exhibitions::Service.register_order( exhibition_id, item_id, number )
      end

      def update_order( exhibition_id, item_id, number, last_number)
        Exhibitions::Service.update_order( exhibition_id, item_id, number, last_number )
      end

      def store_translations(translations, item_id)
        Items::Service.store_translations( translations, item_id ) if translations
      end

      def update_translations( translations, item_id )
        Items::Service.update_translations( translations, item_id ) if translations
      end

      def manage_exception( message )
        begin
          yield
        rescue Exception => error
          error
        end
      end
    end
  end
end
