module Exhibitions
  class Repository
    @content = []

    class << self
      def store(exhibition)
        @content << exhibition
        exhibition
      end

      def retrieve(id)
        @content ||= []
        result = @content.find { |exhibition| exhibition.id == id }
        result
      end

      def update(exhibition)
        current_exhibition = @content.find { |element| element.id == exhibition.id }
        index = @content.index(current_exhibition)
        @content[index] = exhibition
        exhibition
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
