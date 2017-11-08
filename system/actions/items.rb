module Actions
  class Item
    class << self
      def add( data )
        exist = ensure_new_item( data['exhibition_id'], data['number'] )
        return exist if exist.class == RuntimeError
        return add_scene( data ) if data['room'] == false
        return add_room( data ) if data['room'] == true
      end

      private

      def ensure_new_item( exhibition_id, number )
        message_exception = 'Store or update item number error, number allready exist'
        result = manage_exception( message_exception ) do
          exhibition = Exhibitions::Service.retrieve( exhibition_id )
          numbers = exhibition[:order][:index].keys || []
          raise message_exception if numbers.include? number
        end
        result
      end

      def add_scene( data )
        result = Items::Service.store_scene(data)
        item_id = result[:id]
        number = data['number']
        Exhibitions::Service.register_order(data['exhibition_id'], item_id, number)
        translations = Items::Service.store_translations(data['translations'], item_id) if data['translations']
        result['translations'] = translations
        result
      end

      def add_room( data )
        message_exception = 'Store or update item error'
        result = manage_exception(message_exception) do
          result = Items::Service.store_room(data)
          item_id = result[:id]
          number = data['number']
          Exhibitions::Service.register_order(data['exhibition_id'], item_id, number)
          translations = Items::Service.store_translations(data['translations'], item_id) if data['translations']
          result['translations'] = translations
          result
        end
      end
      
      def manage_exception(message)
        begin
          yield
        rescue Exception => error
          error
        end
      end
    end
  end
end
