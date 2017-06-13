class Price
  def initialize(data)
    @free_entrance = Defense.array_null_defense(data['freeEntrance'])
    @general = Defense.array_null_defense(data['general'])
    @reduced = Defense.array_null_defense(data['reduced'])
  end

  def serialize
    { freeEntrance: @free_entrance, general: @general, reduced: @reduced }
  end
end
