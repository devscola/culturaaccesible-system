class Contact
  def initialize(data)
    @phone = Defense.array_null_defense(data['phone'])
    @email = Defense.array_null_defense(data['email'])
    @web = Defense.array_null_defense(data['web'])
  end

  def serialize
    { phone: @phone, email: @email, web: @web }
  end
end
