module Museums
  class Museum
    def initialize(data)
      @info = Info.new(data['info'] || {})
      @location = Location.new(data['location'] || {})
      @contact = Contact.new(data['contact'] || {})
      @price = Price.new(data['price'] || {})
      @schedule = Schedule.new(data['schedule'] || {})
    end

    def serialize
      {
        info: info.serialize,
        location: location.serialize,
        contact: contact.serialize,
        price: price.serialize,
        schedule: schedule.serialize
      }
    end

    def info
      @info
    end

    private

    def location
      @location
    end

    def contact
      @contact
    end

    def price
      @price
    end

    def schedule
      @schedule
    end
  end
end

class Info
  def initialize(data)
    @name = Defense::string_null_defense(data['name'])
    @description = Defense::string_null_defense(data['description'])
  end

  def name
    @name
  end

  def serialize
    {
      name: @name,
      description: @description
    }
  end
end

class Location
  def initialize(data)
    @street = Defense::string_null_defense(data['street'])
    @postal = Defense::string_null_defense(data['postal'])
    @city = Defense::string_null_defense(data['city'])
    @region = Defense::string_null_defense(data['region'])
    @link = Defense::string_null_defense(data['link'])
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

class Contact
  def initialize(data)
    @phone = Defense::array_null_defense(data['phone'])
    @email = Defense::array_null_defense(data['email'])
    @web = Defense::array_null_defense(data['web'])
  end

  def serialize
    {
      phone: @phone,
      email: @email,
      web: @web
    }
  end
end

class Price
  def initialize(data)
    @free_entrance = Defense::array_null_defense(data['freeEntrance'])
    @general = Defense::array_null_defense(data['general'])
    @reduced = Defense::array_null_defense(data['reduced'])
  end

  def serialize
    {
      freeEntrance: @free_entrance,
      general: @general,
      reduced: @reduced
    }
  end
end

class Schedule
  def initialize(data)
    @mon = Defense::array_null_defense(data['MON'])
    @tue = Defense::array_null_defense(data['TUE'])
    @wed = Defense::array_null_defense(data['WED'])
    @thu = Defense::array_null_defense(data['THU'])
    @fri = Defense::array_null_defense(data['FRI'])
    @sat = Defense::array_null_defense(data['SAT'])
    @sun = Defense::array_null_defense(data['SUN'])
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

class Defense
  class << self
    def string_null_defense(value)
      value || ''
    end

    def array_null_defense(value)
      value || []
    end
  end
end
