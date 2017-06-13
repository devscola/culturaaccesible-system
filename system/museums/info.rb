class Info
  def initialize(data)
    @name = Defense.string_null_defense(data['name'])
    @description = Defense.string_null_defense(data['description'])
  end

  def name
    @name
  end

  def serialize
    { name: @name, description: @description }
  end
end
