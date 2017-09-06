module Items
  class Translation
    def initialize(data, item_id=nil)
      @name = null_defense(data['name'])
      @description = null_defense(data['description'])
      @video = null_defense(data['video'])
      @iso_code = null_defense(data['iso_code'])
      @item_id = item_id
    end

    def serialize
      {
        name: @name,
        description: @description,
        video: @video,
        iso_code: @iso_code,
        item_id: @item_id
      }
    end

    def self.from_bson(bson, id)
      Items::Translation.new(bson, id)
    end

    private

    def null_defense(value)
      value || ''
    end
  end
end
