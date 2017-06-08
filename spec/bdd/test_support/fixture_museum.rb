class Fixture
  class Museum
    extend Capybara::DSL

    MUSEUM_ENOUGH_DATA = {
      'name' => 'Some name',
      'street' => 'Some street',
    }

    EXTRA_PHONE = 'extra phone'

    class << self
      def initial_state
        Page::Museum.new
      end

      def showing_form
        current = initial_state
        current.click_new_museum
        current
      end

      def enough_content
        current = showing_form

        MUSEUM_ENOUGH_DATA.each do |field, content|
          current.fill_input(field, content)
        end

        current
      end

      def contact_section_with_an_extra_input
        current = enough_content
        current.fill_input('phone1', 'some phone')
        current.add_input('.phone')
        current
      end
    end
  end
end
