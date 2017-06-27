module Fixture
  class Museum
    extend Capybara::DSL

    MANDATORY_DATA = {
      'name' => 'Some name',
      'street' => 'Some street'
    }

    EXTRA_PHONE = '99999999'
    PHONE = '000000000'

    HOUR_OUT_OF_RANGE = '23:00-24:00'
    MINUTES_OUT_OF_RANGE = '08:60-14:00'
    HOUR_WITH_ONE_DIGIT = '8:00-14:00'
    INVALID_HOUR_RANGE = '09:00-08:00'
    HOUR = '08:00-14:00'
    ALTERNATIVE_HOUR = '16:00-20:00'
    MONDAY = 'MON'
    TUESDAY = 'TUE'
    NOT_DUPLICATED_SCHENDULE_HOUR = 'TUE 08:00-14:00'

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

      def submitted
        current = Fixture::Museum.fill_mandatory_content
        current.fill_input('phone1', PHONE)
        current.click_checkbox(MONDAY)
        current.introduce_hours(HOUR)
        current.click_add_hour
        current.submit
        current
      end

      def contact_section_with_an_extra_input
        current = fill_mandatory_content
        current.fill_input('phone1', PHONE)
        current.add_input('.phone')
        current
      end
    end
  end
end
