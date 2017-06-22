module Items
  class Repository
    @content = []

    class << self
      def store(item)
        @content << item
        item
      end
    end
  end
end
