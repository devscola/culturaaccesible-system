module Items
  class Room
    attr_reader :name, :id, :parent_id

    def initialize(data, id = nil)
      @creation_date = Time.now.utc
      @name = null_defense(data['name'])
      @number = null_defense(data['number'])
      @beacon = null_defense(data['beacon'])
      @description = null_defense(data['description'])
      @parent_id = null_defense(data['parent_id'])
      @id = id || generate_id
    end

    def serialize
      {
        name: @name,
        number: @number,
        beacon: @beacon,
        description: @description,
        parent_id: @parent_id,
        id: @id,
        type: 'room'
      }
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
