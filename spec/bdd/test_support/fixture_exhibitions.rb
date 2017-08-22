require_relative 'fixture_museum'

module Fixture
  class Exhibitions
    extend Capybara::DSL

    NAME_FIELD = 'name'
    LOCATION_FIELD = 'location'
    MUSEUM_FIELD = 'museums'
    NAME = 'some name'
    OTHER_NAME = 'some other name'
    LOCATION = 'some location'
    REDIRECTED_PAGE_TITLE = 'Item'
    EXHIBITION_NAME = 'Name: some name'
    IMAGE = 'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg'

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
        current.select_museum(Fixture::Museum::OTHER_NAME)
        current
      end

      def exhibition_saved
        create_museums
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

      def exhibition_edited
        current = exhibition_saved
        current.click_edit
        current.fill(NAME_FIELD, OTHER_NAME)
        current
      end

      def two_exhibitions_introduced
        create_museums
        current = show_exhibition_form
        current.fill(NAME_FIELD, NAME)
        current.select_museum(Fixture::Museum::NAME)
        current.save

        current.show
        current.fill(NAME_FIELD, OTHER_NAME)
        current.select_museum(Fixture::Museum::OTHER_NAME)
        current.save
        current
      end

      def create_museums
        Fixture::Museum.pristine.fill_with_extra_content
        Fixture::Museum.fill_other_museum
      end
    end
  end
end
