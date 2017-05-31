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

    class << self
      def enough_content
        current = Page::Museum.new

        MUSEUM_DATA.each do |field, content|
          current.fill_input(field, content)
        end

        current
      end
    end
  end
end
