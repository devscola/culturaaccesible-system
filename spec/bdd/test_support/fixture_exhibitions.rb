module Exhibitions
  class Fixture
    extend Capybara::DSL

    NAME_FIELD = 'name'
    LOCATION_FIELD = 'location'
    NAME = 'some name'
    OTHER_NAME = 'some other name'
    LOCATION = 'some location'

    class << self

      def pristine
        visit('/api/exhibition/flush')
        self
      end

      def show_exhibition_form
        current = Page::Exhibitions.new
        current.show
        current
      end

      def fill_form
        current = Page::Exhibitions.new
        current.show

        current.fill(NAME_FIELD, NAME)
        current.fill(LOCATION_FIELD, LOCATION)

        current
      end

      def exhibition_saved
        current = Fixture.fill_form
        current.save
        current
      end

      def exhibition_edited
        current = Fixture.exhibition_saved
        current.click_edit
        current.fill(NAME_FIELD, OTHER_NAME)
        current
      end

      def two_exhibitions_introduced(name, other_name)
        current = Fixture.show_exhibition_form
        current.fill(NAME_FIELD, name)
        current.fill(LOCATION_FIELD, LOCATION)
        current.save

        current.show
        current.fill(NAME_FIELD, other_name)
        current.fill(LOCATION_FIELD, LOCATION)
        current.save
        current
      end
    end
  end
end
