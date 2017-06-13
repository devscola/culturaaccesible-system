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
