module Exhibitions
  class Exhibition
    attr_reader :id, :name, :order, :show

    def initialize(data, id=nil, order=nil)
      @creation_date = Time.now.utc
      @show = Defense.string_null_defense(data['show'])
      @name = Defense.string_null_defense(data['name'])
      @location = Defense.string_null_defense(data['location'])
      @short_description = Defense.string_null_defense(data['short_description'])
      @date_start = Defense.string_null_defense(data['date_start'])
      @date_finish = Defense.string_null_defense(data['date_finish'])
      @type = Defense.string_null_defense(data['type'])
      @beacon = Defense.string_null_defense(data['beacon'])
      @description = Defense.string_null_defense(data['description'])
      @image = Defense.string_null_defense(data['image'])
      @id = id || generate_id
      @order = order || Order.new
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
        description: @description,
        image: @image,
        order: @order.serialize
      }
    end

    def self.from_bson(bson, id, order)
      order = Order.new(order)
      exhibition = Exhibitions::Exhibition.new(bson, id, order)
      exhibition
    end

    private

    def generate_id
      Digest::MD5.hexdigest(@creation_date.to_s + @creation_date.nsec.to_s + @name)
    end
  end
end
