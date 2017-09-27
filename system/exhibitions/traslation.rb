module Exhibitions
  class Translation
    def initialize(data, exhibition_id, id = nil)
      @name = null_defense(data['name'])
      @general_description = null_defense(data['description'])
      @extended_description = null_defense(data['short_description'])
      @iso_code = null_defense(data['iso_code'])
      @exhibition_id = exhibition_id
      @id = id || generate_id
    end

    def serialize
      {
        id: @id,
        name: @name,
        general_description: @general_description,
        extended_description: @extended_description,
        iso_code: @iso_code,
        exhibition_id: @exhibition_id
      }
    end

    def self.from_bson(bson, exhibition_id, id)
      Exhibitions::Translation.new(bson, exhibition_id, id)
    end

    private

    def null_defense(value)
      value || ''
    end

    def generate_id
      Digest::MD5.hexdigest('translation' + @name + @iso_code + Time.now.utc.nsec.to_s)
    end
  end
end
