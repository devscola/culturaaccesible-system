module Exhibitions
  class Exhibition
    attr_reader :name

    def initialize(data)
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
    end

    def serialize
      {
        creation_date: @creation_date,
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

    def null_defense(value)
      value || ''
    end
  end
end
