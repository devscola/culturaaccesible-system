module Museums
  class Repository
    @@content = []

    class << self
      def store(museum_data)
        museum = Museums::Museum.new(museum_data)
        @@content << museum
        museum
      end

      def retrieve(name)
        @@content ||= []
        result = @@content.find { |museum| museum.info.name == name }
        result
      end

      def all
        @@content
      end
    end
  end
end
