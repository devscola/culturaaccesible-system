class Fixture
  class Museum
    extend Capybara::DSL

    MUSEUM_DATA = {
      'name' => 'Some name',
      'description' => 'Extra text',
      'street' => 'Some street',
      'postal' => 'Some postal',
      'city' => 'Some city',
      'region' => 'Some region',
      'link' => 'Some Google Maps link'
    }

    CONTACT = {
      'phone1' => 'some phone',
      'email1' => 'some email',
      'web1' => 'some web'
    }

    EXTRA_PHONE = 'extra phone'

    class << self
      def enough_content
        current = Page::Museum.new

        MUSEUM_DATA.each do |field, content|
          current.fill_input(field, content)
        end

        current
      end

      def contact_form_shown
        Page::Museum.new
      end

      def contact_form_filled_with_extra_inputs
        current = contact_form_shown
        current.fill_form(CONTACT)
        current.add_input
        current.fill_input('phone2', EXTRA_PHONE)
        current
      end
    end
  end


end
