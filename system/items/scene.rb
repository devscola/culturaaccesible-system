module Items
  class Scene
    attr_reader :name, :id, :parent_id, :type, :description, :author, :date

    def initialize(data, id=nil)
      @creation_date = Time.now.utc
      @name = null_defense(data['name'])
      @author = null_defense(data['author'])
      @date = null_defense(data['date'])
      @beacon = null_defense(data['beacon'])
      @description = null_defense(data['description'])
      @image = null_defense(data['image'])
      @video = null_defense(data['video'])
      @parent_id = null_defense(data['parent_id'])
      @parent_class = null_defense(data['parent_class'])
      @type = 'scene'
      @id = id || generate_id
    end

    def serialize
      {
        name: @name,
        author: @author,
        date: @date,
        beacon: @beacon,
        description: @description,
        image: @image,
        video: @video,
        parent_id: @parent_id,
        parent_class: @parent_class,
        id: @id,
        type: @type
      }
    end

    def self.from_bson(bson, id)
      Items::Scene.new(bson, id)
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
