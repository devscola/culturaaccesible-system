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
    @name = data['name']
    @description = data['description']
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
    @street = data['street']
    @postal = data['postal']
    @city = data['city']
    @region = data['region']
    @link = data['link']
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
    @phone = data['phone']
    @email = data['email']
    @web = data['web']
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
    @free_entrance = data['freeEntrance']
    @general = data['general']
    @reduced = data['reduced']
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
    @mon = data['MON']
    @tue = data['TUE']
    @wed = data['WED']
    @thu = data['THU']
    @fri = data['FRI']
    @sat = data['SAT']
    @sun = data['SUN']
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
