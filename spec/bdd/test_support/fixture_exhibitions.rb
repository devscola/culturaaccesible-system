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
    LINK = 'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg'

    class << self

      def pristine
        visit('/api/exhibition/flush')
        self
      end

      def up
        visit('/api/exhibition/flush')
        visit('/api/fixtures/exhibition')
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

      def exhibition_saved_with_subscenes
        Fixture::Item.from_exhibition_to_new_item

        Fixture::Item.item_saved
        Fixture::Item.item_saved_in_item

        Page::Exhibitions.new
      end

      def put_a_fucking_item

      end

      def complete_exhibition
        current = exhibition_saved
        current.add_room
        current = Page::Exhibitions.new
        current.click_plus_button
        Page::Item.new

        Fixture::Item.item_saved
        Fixture::Item.item_saved_in_item

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
