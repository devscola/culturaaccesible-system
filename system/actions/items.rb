module Actions
  class Item
    class << self
      def add( data )
        assigned_number = check_assigned_number( data['exhibition_id'], data['number'] )
        return assigned_number if assigned_number.class == RuntimeError
        return add_scene( data ) if data['room'] == false
        return add_room( data ) if data['room'] == true
      end

      def update( data )
        return update_item( data, method( :store_scene )) if data['room'] == false
        return update_item( data, method( :store_room )) if data['room'] == true
      end

      def retrieve( exhibition_id, item_id )
        item = retrieve_item( item_id )
        item_id = item[:id]
        item['translations'] = retrieve_translations( item_id )
        message_exception = 'Item not found'
        item = manage_exception(message_exception) do
          ordinal = Exhibitions::Service.retrieve_ordinal(exhibition_id, item_id)
          item['number'] = ordinal
          item
        end
      end

      private

      def check_assigned_number( exhibition_id, number )
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
        scene = store_scene( data )
        item_id = scene[:id]
        register_order( data['exhibition_id'], item_id, number )
        scene['translations'] = store_translations( data['translations'], item_id )
        scene
      end

      def add_room( data )
        message_exception = 'Store or update item error'
        room = manage_exception(message_exception) do
          number = data['number']
          room = store_room( data )
          item_id = room[:id]
          register_order( data['exhibition_id'], item_id, number )
          room['translations'] = store_translations( data['translations'], item_id )
          room
        end
      end

      def update_item( data, action )
        message_exception = "Room to scene or scene to room change not allowed"
        item = manage_exception(message_exception) do
          number = data['number']
          last_number = data['last_number']
          item = action.call( data )
          item_id = item[:id]
          update_order( data['exhibition_id'], item_id, number, last_number )
          item['translations'] = update_translations( data['translations'], item_id )
          item
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
