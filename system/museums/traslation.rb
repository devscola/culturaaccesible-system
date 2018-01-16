module Museums
  class Translation
    def initialize(data, museum_id, id = nil)
      @description = Defense.string_null_defense(data['description'])
      @iso_code = Defense.string_null_defense(data['iso_code'])
      @museum_id = museum_id
      @id = id || generate_id
    end

    def serialize
      {
        id: @id,
        description: @description,
        iso_code: @iso_code,
        museum_id: @museum_id
      }
    end

    def self.from_bson(bson, museum_id, id)
      Museums::Translation.new(bson, museum_id, id)
    end

    private

    def generate_id
      Digest::MD5.hexdigest('translation' + @iso_code + Time.now.utc.nsec.to_s)
    end
  end
end
