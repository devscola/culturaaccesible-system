module Domain
  class Exhibition
    def initialize(data)
      @id = data['id']
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
  end
end
