module Museums
  class Repository
    @content = []

    class << self
      def store(museum_data)
        museum = Museums::Museum.new(museum_data)
        @content << museum
        museum
      end

      def retrieve(id)
        @content ||= []
        result = @content.find { |museum| museum.id == id }
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
