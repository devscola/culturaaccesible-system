class Fixture
  class Item
    extend Capybara::DSL

    class << self
      def initial_state
        Page::Item.new
      end
    end
  end
end
