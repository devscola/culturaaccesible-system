module Exhibitions
  class Exhibition
    attr_reader :name

    def initialize(data)
      @show = data['show']
      @name = data['name']
      @location = data['location']
      @short_description = data['short_description']
      @date_start = data['date_start']
      @date_finish = data['date_finish']
      @type = data['type']
      @beacon = data['beacon']
      @description = data['description']
    end

    def serialize
      {
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
  end
end
