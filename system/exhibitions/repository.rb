module Exhibitions
  class Repository
    @content = []

    class << self
      def choose_action(exhibition_data)
        id = exhibition_data['id']
        if (id)
          result = update(exhibition_data)
        else
          result = store(exhibition_data)
        end
      end

      def retrieve(id)
        @content ||= []
        result = @content.find { |exhibition| exhibition.id == id }
        result
      end

      def all
        @content.map do |exhibition|
          {
            "id": exhibition.id,
            "name": exhibition.name
          }
        end
      end

      def retrieve_next_ordinal(exhibition_id, ordinal)
        exhibition = retrieve(exhibition_id)
        exhibition.order.next_child(ordinal)
      end

      def flush
        @content = []
      end

      def add_number(exhibition_id, number)
        exhibition = retrieve(exhibition_id)
        exhibition.set_numbers(number)
      end

      private

      def update(exhibition_data)
        id =  exhibition_data['id']
        exhibition = Exhibitions::Exhibition.new(exhibition_data, id)

        current_exhibition = @content.find { |element| element.id == exhibition.id }
        index = @content.index(current_exhibition)
        @content[index] = exhibition
        @content[index]
      end

      def store(exhibition_data)
        exhibition = Exhibitions::Exhibition.new(exhibition_data)

        @content << exhibition
        exhibition
      end
    end
  end
end
