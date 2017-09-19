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

  # class XMuseum
  #   extend Capybara::DSL

  #   NAME = 'Some name'
  #   STREET = 'Some street'

  #   MANDATORY_DATA = {
  #     'name' => NAME,
  #     'street' => STREET
  #   }

  #   OTHER_NAME = 'Other museum'
  #   OTHER_STREET = 'Other street'

  #   EXTRA_PHONE = '99999999'
  #   PHONE = '000000000'
  #   OTHER_PHONE = '123456789'

  #   PRICE = '25'
  #   OTHER_PRICE = '30'

  #   HOUR_OUT_OF_RANGE = '23:00-24:00'
  #   MINUTES_OUT_OF_RANGE = '08:60-14:00'
  #   HOUR_WITH_ONE_DIGIT = '8:00-14:00'
  #   INVALID_HOUR_RANGE = '09:00-08:00'
  #   HOUR = '08:00-14:00'
  #   ALTERNATIVE_HOUR = '16:00-20:00'
  #   MONDAY = 'MON'
  #   TUESDAY = 'TUE'
  #   NOT_DUPLICATED_SCHEDULE_HOUR = 'MON 08:00-14:00'
  #   DUPLICATED_SCHEDULE_HOUR = 'MON 08:00-14:00 08:00-14:00'
  #   MAP_LINK = "https://www.google.es/maps/place/Institut+Valenci%C3%A0+d'Art+Modern/@39.4723137,-0.3909856,15z"

  #   STREET_FIELD = 'street'
  #   NAME_FIELD = 'name'
  #   MAP_LINK_FIELD = 'link'
  #   PHONE_FIELD = 'phone1'
  #   PRICE_FIELD = 'freeEntrance1'

  #   class << self

  #     def pristine
  #       visit('/api/museum/flush')
  #       self
  #     end

  #     def initial_state
  #       Page::Museum.new
  #     end

  #     def showing_form
  #       current = initial_state
  #       current.click_new_museum
  #       current
  #     end

  #     def fill_mandatory_content
  #       current = showing_form

  #       MANDATORY_DATA.each do |field, content|
  #         current.fill_input(field, content)
  #       end

  #       current
  #     end

  #     def fill_with_extra_content
  #       current = Fixture::Museum.fill_mandatory_content
  #       current.fill_input(PHONE_FIELD, PHONE)
  #       current.fill_input(PRICE_FIELD, PRICE)
  #       current.fill_input(MAP_LINK_FIELD, MAP_LINK)
  #       current.click_checkbox(MONDAY)
  #       current.introduce_hours(HOUR)
  #       current.click_add_hour
  #       current.submit
  #       current
  #     end

  #     def fill_other_museum
  #       current = showing_form
  #       current.fill_input('name', OTHER_NAME)
  #       current.fill_input('street', OTHER_STREET)
  #       current.submit
  #     end

  #     def contact_section_with_an_extra_input
  #       current = fill_mandatory_content
  #       current.fill_input('phone1', PHONE)
  #       current.add_input('.phone')
  #       current
  #     end

  #     def add_content_with_extra_phones_and_prices
  #       current = fill_mandatory_content
  #       current.fill_input('phone1', PHONE)
  #       current.add_input('.phone')
  #       current.fill_input('phone2', OTHER_PHONE)
  #       current.fill_input('general1', PRICE)
  #       current.add_input('.general')
  #       current.fill_input('general2', OTHER_PRICE)
  #       current
  #     end
  #   end
  # end

end
