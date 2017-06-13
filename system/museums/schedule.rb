class Schedule
  def initialize(data)
    @mon = Defense.array_null_defense(data['MON'])
    @tue = Defense.array_null_defense(data['TUE'])
    @wed = Defense.array_null_defense(data['WED'])
    @thu = Defense.array_null_defense(data['THU'])
    @fri = Defense.array_null_defense(data['FRI'])
    @sat = Defense.array_null_defense(data['SAT'])
    @sun = Defense.array_null_defense(data['SUN'])
  end

  def serialize
    {
      MON: @mon,
      TUE: @tue,
      WED: @wed,
      THU: @thu,
      FRI: @fri,
      SAT: @sat,
      SUN: @sun
    }
  end
end
