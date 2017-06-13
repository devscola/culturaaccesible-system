class Location
  def initialize(data)
    @street = Defense.string_null_defense(data['street'])
    @postal = Defense.string_null_defense(data['postal'])
    @city = Defense.string_null_defense(data['city'])
    @region = Defense.string_null_defense(data['region'])
    @link = Defense.string_null_defense(data['link'])
  end

  def serialize
    {
      street: @street,
      postal: @postal,
      city: @city,
      region: @region,
      link: @link
    }
  end
end
