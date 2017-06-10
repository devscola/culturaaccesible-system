module Museums
  class Museum
    attr_reader :info, :location, :contact, :price, :schedule
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
  end
end

class Info
  attr_reader :name, :description
  def initialize(data)
    @name = data['name']
    @description = data['description']
  end

  def serialize
    {
      name: @name,
      description: @description
    }
  end
end

class Location
  attr_reader :street, :postal, :city, :region, :link
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
  attr_reader :phone, :email, :web
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
  attr_reader :free_entrance, :general, :reduced
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
  attr_reader :mon, :tue, :wed, :thu, :fri, :sat, :sun
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
