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

      def all
        @content
      end

      def flush
        @content = []
      end
    end
  end
end
