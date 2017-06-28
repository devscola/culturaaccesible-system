module Fixture
  class Item
    extend Capybara::DSL

    ERROR_LENGTH_DATE = '19865'
    ARTWORK = 'Guernica'
    VISIBLE_ARTWORK = 'Name: Guernica'

    class << self
      def initial_state
        Page::Item.new
      end

      def from_exhibition_to_new_item
        current = Fixture::Exhibitions.pristine.exhibition_saved
        exhibition_name = current.first_exhibition_name
        current.click_plus_button
        initial_state
      end
    end
  end
end
