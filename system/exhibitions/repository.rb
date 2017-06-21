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

      def update(updated_exhibition)
        current_exhibition = @content.find { |exhibition| exhibition.id == updated_exhibition.id }
        index = @content.index(current_exhibition)
        @content[index] = updated_exhibition
        updated_exhibition
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
