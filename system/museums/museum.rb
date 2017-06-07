module Museums
  class Museum
    attr_reader :id

    def initialize(data)
      @id = data['id']
      @name = data['name']
      @description = data['description']
      @street = data['street']
      @postal = data['postal']
      @city = data['city']
      @region = data['region']
      @link = data['link']
      @contact = data['contact']
      @price = data['price']
      @schedule = data['schedule']
    end

    def serialize
      {
        id: @id,
        name: @name,
        description: @description,
        street: @street,
        postal: @postal,
        city: @city,
        region: @region,
        link: @link,
        contact: @contact,
        price: @price,
        schedule: @schedule
      }
    end
  end
end
