require 'httparty'
require 'json'

module Fixture
  class Museum
    extend Capybara::DSL

    MANDATORY_DATA = {
      'name' => 'Some name',
      'street' => 'Some street'
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

    class << self
      def initial_state
        Page::Museum.new
      end

      def showing_form
        current = initial_state
        current.click_new_museum
        current
      end

      def fill_mandatory_content
        current = showing_form

        MANDATORY_DATA.each do |field, content|
          current.fill_input(field, content)
        end

        current
      end

      def fill_with_extra_content
        current = Fixture::Museum.fill_mandatory_content
        current.fill_input('phone1', PHONE)
        current.click_checkbox(MONDAY)
        current.introduce_hours(HOUR)
        current.click_add_hour
        current.submit
        current
      end

      def fill_other_museum
        current = showing_form
        current.fill_input('name', 'Other museum')
        current.fill_input('street', 'Other street')
        current.submit
      end

      def contact_section_with_an_extra_input
        current = fill_mandatory_content
        current.fill_input('phone1', PHONE)
        current.add_input('.phone')
        current
      end

      def add_content_with_extra_phones_and_prices
        current = fill_mandatory_content
        current.fill_input('phone1', PHONE)
        current.add_input('.phone')
        current.fill_input('phone2', OTHER_PHONE)
        current.fill_input('general1', PRICE)
        current.add_input('.general')
        current.fill_input('general2', OTHER_PRICE)
        current
      end
    end
  end

  class XMuseum
    FIRST_MUSEUM = 'Muvim'
    SECOND_MUSEUM = 'El Prado'
    FIRST_STREET = 'Valencia'
    SECOND_STREET = 'Madrid'

    class << self
      def complete_scenario
        add_museum(FIRST_MUSEUM, FIRST_STREET)
        add_museum(SECOND_MUSEUM, SECOND_STREET)
      end

      def add_museum(name, street)
        museum = { info: { name: name }, location: { street: street } }.to_json
        HTTParty.post('http://localhost:4567/api/museum/add', { body: museum })
      end
    end
  end
end
