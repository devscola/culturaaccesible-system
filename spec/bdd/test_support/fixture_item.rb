module Fixture
  class Item
    extend Capybara::DSL

    ERROR_LENGTH_DATE = '19865'
    DATE = '1937'
    AUTHOR = 'Picasso'
    ARTWORK = 'Guernica'
    VISIBLE_ARTWORK = 'Name: Guernica'
    FIRST_NUMBER = 1
    SECOND_NUMBER = 2
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
    end
  end
end
