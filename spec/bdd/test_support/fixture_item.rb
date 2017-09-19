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
    VISIBLE_AUTHOR = 'Author: Picasso'
    FIRST_NUMBER = 1
    SECOND_NUMBER = 2
    THIRD_NUMBER = 3
    INFO_FIRST_NUMBER = 'Number: 1'
    INFO_SECOND_NUMBER = 'Number: 2'
    INFO_THIRD_NUMBER = 'Number: 3'
    REPEATED_NUMBER = FIRST_NUMBER
    SAVE_BUTTON = 'Save'

    class << self
      def initial_state
        Page::Item.new
      end

      def get_an_item_form
        Page::Exhibitions.new.click_plus_button
        Page::Item.new
      end

      def from_exhibition_to_new_item
        current = Fixture::Exhibitions.pristine.complete_exhibition
        current.click_plus_button
        initial_state
      end

      def from_exhibition_to_second_item
        current = Fixture::Exhibitions.exhibition_saved
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

      def room_saved(number = FIRST_NUMBER)
        current = initial_state

        current.check_room
        current.fill('name', ARTWORK)
        current.fill('number', number)

        current.submit
      end

      def item_saved
        current = initial_state

        current.fill('name',Fixture::Item::ARTWORK)
        current.fill('number',Fixture::Item::SECOND_NUMBER)
        current.fill('author', Fixture::Item::AUTHOR)
        current.fill('date', Fixture::Item::DATE)

        current.submit
      end

      def item_filled
        current = initial_state

        current.fill('name',Fixture::Item::ARTWORK)
        current.fill('number',Fixture::Item::SECOND_NUMBER)
        current.fill('author',Fixture::Item::AUTHOR)

        current

      end

      def item_saved_in_room(number = SECOND_NUMBER)
        current = Page::Exhibitions.new
        current.toggle_list
        current.click_room_plus_button

        current = Page::Item.new
        current.fill('name',Fixture::Item::OTHER_ARTWORK)
        current.fill('number', number)

        current.submit
      end

      def item_saved_in_item(number = THIRD_NUMBER)
        current = Page::Exhibitions.new
        current.toggle_list
        current.click_item_plus_button

        current = Page::Item.new
        current.fill('name',Fixture::Item::OTHER_ARTWORK)
        current.fill('number', number)

        current.submit
      end

      def scene_saved_with_automatic_number
        current = initial_state

        current.fill('name',Fixture::Item::ARTWORK)
        current.submit
      end

      def room_saved_with_automatic_number
        current = initial_state

        current.check_room
        current.fill('name', ARTWORK)

        current.submit
      end

      def scene_saved_in_room_with_automatic_number
        current = Page::Exhibitions.new
        current.toggle_list
        current.click_room_plus_button

        current = Page::Item.new
        current.fill('name',Fixture::Item::OTHER_ARTWORK)

        current.submit
      end

      def subscene_saved_in_scene_with_automatic_number
        current = Page::Exhibitions.new
        current.toggle_list
        current.click_item_plus_button

        current = Page::Item.new
        current.fill('name',Fixture::Item::OTHER_ARTWORK)

        current.submit
      end

      def subscene_saved_in_second_scene_with_automatic_number
        current = Page::Exhibitions.new
        current.toggle_list
        current.click_last_item_plus_button

        current = Page::Item.new
        current.fill('name',Fixture::Item::OTHER_ARTWORK)

        current.submit
      end
    end
  end
end
