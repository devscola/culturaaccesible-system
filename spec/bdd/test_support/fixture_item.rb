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
    end
  end
end
