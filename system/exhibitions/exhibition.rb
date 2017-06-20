module Exhibitions
  class Exhibition
    attr_reader :id

    def initialize(data, id=nil)
      @creation_date = Time.now.utc
      @show = null_defense(data['show'])
      @name = null_defense(data['name'])
      @location = null_defense(data['location'])
      @short_description = null_defense(data['short_description'])
      @date_start = null_defense(data['date_start'])
      @date_finish = null_defense(data['date_finish'])
      @type = null_defense(data['type'])
      @beacon = null_defense(data['beacon'])
      @description = null_defense(data['description'])
      @id = id || generate_id
    end

    def serialize
      {
        creation_date: @creation_date,
        id: @id,
        show: @show,
        name: @name,
        location: @location,
        short_description: @short_description,
        date_start: @date_start,
        date_finish: @date_finish,
        type: @type,
        beacon: @beacon,
        description: @description
      }
    end

    private

    def generate_id
      Digest::MD5.hexdigest(@creation_date.to_s + @creation_date.nsec.to_s + @name)
    end

    def null_defense(value)
      value || ''
    end
  end
end
