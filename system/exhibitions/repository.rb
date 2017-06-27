module Exhibitions
  class Repository
    @content = []

    class << self
      def store(exhibition_data)
        exhibition = Exhibitions::Exhibition.new(exhibition_data)

        @content << exhibition
        exhibition
      end

      def retrieve(id)
        @content ||= []
        result = @content.find { |exhibition| exhibition.id == id }
        result
      end

      def update(exhibition_data)
        id =  exhibition_data['id']
        exhibition = Exhibitions::Exhibition.new(exhibition_data, id)

        current_exhibition = @content.find { |element| element.id == exhibition.id }
        index = @content.index(current_exhibition)
        @content[index] = exhibition
        @content[index]
      end

      def all
        @content
      end

      def flush
        @content = []
      end
    end
  end
end
