module Museums
  class Repository
    @content = []

    class << self
      def store(museum_data)
        museum = Museums::Museum.new(museum_data)
        @content << museum
        museum
      end

      def update(museum_data)
        museum = retrieve(museum_data['id'])
        index = @content.index(museum)

        updated_museum = Museums::Museum.new(museum_data, museum.id)

        @content[index] = updated_museum
        @content[index]
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
