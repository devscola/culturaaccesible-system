module Contacts
  class Contact
    def initialize(data)
      @phone = data['phone']
      @email = data['email']
      @web = data['web']
    end

    def serialize
      { phone: @phone, email: @email, web: @web }
    end
  end
end
