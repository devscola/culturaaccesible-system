module Items
  class Translation
    def initialize(data, item_id, id = nil)
      @name = null_defense(data['name'])
      @description = null_defense(data['description'])
      @video = null_defense(data['video'])
      @iso_code = null_defense(data['iso_code'])
      @item_id = item_id
      @id = id || generate_id
    end

    def serialize
      {
        id: @id,
        name: @name,
        description: @description,
        video: @video,
        iso_code: @iso_code,
        item_id: @item_id
      }
    end

    def self.from_bson(bson, item_id, id)
      Items::Translation.new(bson, item_id, id)
    end

    private

    def null_defense(value)
      value || ''
    end

    def generate_id
      Digest::MD5.hexdigest('translation' + @name + @description + Time.now.utc.nsec.to_s)
    end
  end
end
