module Items
  class Translation
    def initialize(data, id=nil)
      @description = null_defense(data['description'])
      @iso_code = null_defense(data['iso_code'])
      @video = null_defense(data['video'])
      @id = id
    end

    def serialize
      {
        id: @id,
        description: @description,
        video: @video,
        iso_code: @iso_code
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
