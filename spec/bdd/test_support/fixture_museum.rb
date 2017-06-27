class Fixture
  class Museum
    extend Capybara::DSL

    MANDATORY_DATA = {
      'name' => 'Some name',
      'street' => 'Some street'
    }

    EXTRA_PHONE = 'extra phone'

    PHONE = '453534543'

    class << self
      def initial_state
        Page::Museum.new
      end

      def showing_form
        current = initial_state
        current.click_new_museum
        current
      end

      def data
        MANDATORY_DATA
      end

      def phone
        PHONE
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
        current.click_checkbox('MON')
        current.introduce_hours('08:00-14:00')
        current.click_add_hour
        current.submit
        current
      end

      def contact_section_with_an_extra_input
        current = fill_mandatory_content
        current.fill_input('phone1', 'some phone')
        current.add_input('.phone')
        current
      end
    end
  end
end
