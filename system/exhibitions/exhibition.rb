module Exhibitions
  class Exhibition
    attr_reader :id, :name, :order, :show, :museum_id
    attr_writer :deleted

    DEFAULT_ISO_CODE = ['es']

    def initialize(data, id=nil, order=nil)
      @creation_date = data['creation_date'] || Time.now.utc
      @show = Defense.string_null_defense(data['show'])
      @name = Defense.string_null_defense(data['name'])
      @museum_id = Defense.string_null_defense(data['museum_id'])
      @general_description = Defense.string_null_defense(data['general_description'])
      @date_start = Defense.string_null_defense(data['date_start'])
      @date_finish = Defense.string_null_defense(data['date_finish'])
      @type = Defense.string_null_defense(data['type'])
      @beacon = Defense.string_null_defense(data['beacon'])
      @description = Defense.string_null_defense(data['description'])
      @image = Defense.string_null_defense(data['image'])
      @id = id || generate_id
      @order = order || Order.new
      @deleted = data['deleted'] || false
      @iso_codes = data['iso_codes'] || DEFAULT_ISO_CODE
    end

    def serialize
      {
        creation_date: @creation_date,
        id: @id,
        show: @show,
        name: @name,
        museum_id: @museum_id,
        general_description: @general_description,
        date_start: @date_start,
        date_finish: @date_finish,
        type: @type,
        beacon: @beacon,
        description: @description,
        image: @image,
        order: @order.serialize,
        deleted: @deleted,
        iso_codes: @iso_codes
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
