module Items
  class Item
    attr_reader :name

    def initialize(data)
      @name = null_defense(data['name'])
      @author = null_defense(data['author'])
      @date = null_defense(data['date'])
      @number = null_defense(data['number'])
      @beacon = null_defense(data['beacon'])
      @description = null_defense(data['description'])
      @exhibition_id = null_defense(data['exhibition_id'])
    end

    def serialize
      {
        name: @name,
        author: @author,
        date: @date,
        number: @number,
        beacon: @beacon,
        description: @description,
        exhibition_id: @exhibition_id
      }
    end

    private

    def null_defense(value)
      value || ''
    end
  end
end
