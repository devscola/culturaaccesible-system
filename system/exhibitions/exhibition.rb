module Exhibitions
  class Exhibition
    attr_reader :id, :name, :order
    attr_accessor :numbers

    def initialize(data, id=nil)
      @creation_date = Time.now.utc
      @show = Defense.string_null_defense(data['show'])
      @name = Defense.string_null_defense(data['name'])
      @location = Defense.string_null_defense(data['location'])
      @short_description = Defense.string_null_defense(data['short_description'])
      @date_start = Defense.string_null_defense(data['date_start'])
      @date_finish = Defense.string_null_defense(data['date_finish'])
      @type = Defense.string_null_defense(data['type'])
      @numbers = Defense.array_null_defense(data['numbers'])
      @beacon = Defense.string_null_defense(data['beacon'])
      @description = Defense.string_null_defense(data['description'])
      @id = id || generate_id
      @index = []
      @order = Order.new
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
        numbers: @numbers,
        beacon: @beacon,
        description: @description,
        index: @index
      }
    end

    def get_numbers
      @numbers
    end

    def set_numbers(number)
      @numbers << number
    end

    private

    def generate_id
      Digest::MD5.hexdigest(@creation_date.to_s + @creation_date.nsec.to_s + @name)
    end
  end
end
