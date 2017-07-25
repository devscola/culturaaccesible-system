module Items
  class Scene
    attr_reader :name, :id, :parent_id, :type


    def initialize(data, exhibition_id, id=nil)
      @creation_date = Time.now.utc
      @name = null_defense(data['name'])
      @author = null_defense(data['author'])
      @date = null_defense(data['date'])
      @number = null_defense(data['number'])
      @beacon = null_defense(data['beacon'])
      @description = null_defense(data['description'])
      @parent_id = null_defense(data['parent_id'])
      @parent_class = null_defense(data['parent_class'])
      @type = 'scene'
      @id = id || generate_id
      @relation = Relation.new(@number, @id, exhibition_id)
    end

    def number
      @number
    end

    def set_number(number)
      @number = number
    end

    def relation
      @relation
    end

    def serialize
      {
        name: @name,
        author: @author,
        date: @date,
        number: @number,
        beacon: @beacon,
        description: @description,
        parent_id: @parent_id,
        parent_class: @parent_class,
        id: @id,
        type: @type,
        relation: @relation.serialize
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
