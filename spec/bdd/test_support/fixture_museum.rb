require 'httparty'
require 'json'

module Fixture
  class Museum
    extend Capybara::DSL

    WEEK = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']

    FIRST_MUSEUM = 'Muvim'
    SECOND_MUSEUM = 'El Prado'
    FIRST_STREET = 'Valencia'
    SECOND_STREET = 'Madrid'
    PAGE_TITLE = 'Museum'
    CAT_DESCRIPTION_FIELD = 'description-cat'
    CAT_DESCRIPTION = 'Descripció exhibició'
    CAT_DESCRIPTION_UPDATED = 'Descripció exhibició actualitzada'

    MANDATORY_DATA = {
      'name' => FIRST_MUSEUM,
      'street' => FIRST_STREET
    }

    EXTRA_PHONE = '99999999'
    PHONE = '000000000'
    OTHER_PHONE = '123456789'

    PRICE = '25'
    OTHER_PRICE = '30'

    HOUR_OUT_OF_RANGE = '23:00-24:00'
    MINUTES_OUT_OF_RANGE = '08:60-14:00'
    HOUR_WITH_ONE_DIGIT = '8:00-14:00'
    INVALID_HOUR_RANGE = '09:00-08:00'
    HOUR = '08:00-14:00'
    ALTERNATIVE_HOUR = '16:00-20:00'
    MONDAY = 'MON'
    TUESDAY = 'TUE'
    NOT_DUPLICATED_SCHEDULE_HOUR = 'MON 08:00-14:00'
    DUPLICATED_SCHEDULE_HOUR = 'MON 08:00-14:00 08:00-14:00'
    MAP_LINK = "https://www.google.es/maps/place/Institut+Valenci%C3%A0+d'Art+Modern/@39.4723137,-0.3909856,15z"

    STREET_FIELD = 'street'
    NAME_FIELD = 'name'
    MAP_LINK_FIELD = 'link'
    PHONE_FIELD = 'phone1'
    PRICE_FIELD = 'freeEntrance1'

    class << self
      def pristine
        HTTParty.get('http://localhost:4567/api/museum/flush')
        self
      end

      def complete_scenario
        add_museum(FIRST_MUSEUM, FIRST_STREET, MAP_LINK)
        add_museum(SECOND_MUSEUM, SECOND_STREET, MAP_LINK)
      end

      def add_museum(name, street, map_link )
        museum = {
          info: { name: name },
          location: { street: street, link: map_link }
          }.to_json
        HTTParty.post('http://localhost:4567/api/museum/add', { body: museum })
      end
    end
  end
end
