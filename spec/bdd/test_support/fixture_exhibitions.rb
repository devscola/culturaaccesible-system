module Fixture
  class Exhibitions
    extend Capybara::DSL

    NAME_FIELD = 'name'
    LOCATION_FIELD = 'location'
    NAME = 'some name'
    OTHER_NAME = 'some other name'
    LOCATION = 'some location'
    REDIRECTED_PAGE_TITLE = 'Item'
    EXHIBITION_NAME = 'Name: some name'

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
        current = fill_form
        current.save
        current
      end

      def exhibition_saved_with_room
        current = exhibition_saved
        current.add_room
        current = Page::Exhibitions.new
        current
      end

      def exhibition_saved_with_item
        current = exhibition_saved
        current.add_item
        Page::Exhibitions.new
      end

      def exhibition_edited
        current = exhibition_saved
        current.click_edit
        current.fill(NAME_FIELD, OTHER_NAME)
        current
      end

      def two_exhibitions_introduced
        current = show_exhibition_form
        current.fill(NAME_FIELD, NAME)
        current.fill(LOCATION_FIELD, LOCATION)
        current.save

        current.show
        current.fill(NAME_FIELD, OTHER_NAME)
        current.fill(LOCATION_FIELD, LOCATION)
        current.save
        current
      end
    end
  end
end
