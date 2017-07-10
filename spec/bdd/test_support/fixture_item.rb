module Fixture
  class Item
    extend Capybara::DSL

    ERROR_LENGTH_DATE = '19865'
    DATE = '1937'
    AUTHOR = 'Picasso'
    ARTWORK = 'Guernica'
    OTHER_ARTWORK = 'La costellazione'
    VISIBLE_ARTWORK = 'Name: Guernica'
    VISIBLE_OTHER_ARTWORK = 'Name: La costellazione'
    FIRST_NUMBER = 1
    SECOND_NUMBER = 2
    THIRD_NUMBER = 3
    REPEATED_NUMBER = FIRST_NUMBER

    class << self
      def initial_state
        Page::Item.new
      end

      def from_exhibition_to_new_item
        current = Fixture::Exhibitions.pristine.exhibition_saved
        current.exhibition_list?
        current.click_plus_button
        initial_state
      end

      def shows_room_alert
        current = from_exhibition_to_new_item

        current.fill('date', Fixture::Item::DATE)
        current.fill('author', Fixture::Item::AUTHOR)

        current.check_room

        current
      end

      def room_saved
        current = initial_state

        current.check_room
        current.fill('name', ARTWORK)
        current.fill('number', FIRST_NUMBER)

        current.submit
      end

      def item_saved
        current = initial_state

        current.fill('name',Fixture::Item::ARTWORK)
        current.fill('number',Fixture::Item::FIRST_NUMBER)

        current.submit
      end

      def item_saved_in_room
        current = Page::Exhibitions.new
        current.click_room_plus_button

        current = Page::Item.new
        current.fill('name',Fixture::Item::OTHER_ARTWORK)
        current.fill('number',Fixture::Item::SECOND_NUMBER)

        current.submit
      end

      def item_saved_in_item
        current = Page::Exhibitions.new
        current.click_item_plus_button

        current = Page::Item.new
        current.fill('name',Fixture::Item::OTHER_ARTWORK)
        current.fill('number',Fixture::Item::THIRD_NUMBER)

        current.submit
      end
    end
  end
end
