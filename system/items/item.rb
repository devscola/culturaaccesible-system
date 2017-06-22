module Items
  class Item
    attr_reader :name

    def initialize(data)
      @name = null_defense(data['name'])
      @exhibition_id = null_defense(data['exhibition_id'])
    end

    def serialize
      {
        name: @name,
        exhibition_id: @exhibition_id
      }
    end

    private

    def null_defense(value)
      value || ''
    end
  end
end
