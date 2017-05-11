module Exhibitions
  class Exhibition < Domain::Exhibition
    attr_reader :id

    def serialize
      {
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
  end
end
