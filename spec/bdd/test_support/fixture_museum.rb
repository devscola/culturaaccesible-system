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

        MUSEUM_DATA.each do |field, content|
          current.fill_input(field, content)
        end

        current
      end
    end
  end


end
