module Items
  class Room
    attr_reader :name, :id, :parent_id, :type, :description

    def initialize(data, id=nil)
      @creation_date = Time.now.utc
      @name = null_defense(data['name'])
      @beacon = null_defense(data['beacon'])
      @description = null_defense(data['description'])
      @image = null_defense(data['image'])
      @parent_id = null_defense(data['parent_id'])
      @parent_class = null_defense(data['parent_class'])
      @type = 'room'
      @id = id || generate_id
    end

    def serialize
      {
        name: @name,
        beacon: @beacon,
        description: @description,
        image: @image,
        parent_id: @parent_id,
        parent_class: @parent_class,
        id: @id,
        type: @type
      }
    end

    def self.from_bson(bson, id)
      Items::Room.new(bson, id)
    end

    def author
      nil
    end

    def date
      nil
    end

    private

    def null_defense(value)
      value || ''
    end

    def generate_id
      Digest::MD5.hexdigest(@creation_date.to_s + @creation_date.nsec.to_s + @name)
    end
  end
end
