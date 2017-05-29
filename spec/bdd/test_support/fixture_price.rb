require_relative 'price'

class Fixture
  extend Capybara::DSL

  PRICES = {
    freeEntrance1: 'free entrance',
    general1: 'general',
    reduced1: 'reduced'
  }

  EXTRA_FREE_ENTRANCE = 'children'

  class << self
    def price_form_shown
      Page::Price.new
    end

    def price_form_filled_with_extra_inputs
      current = price_form_shown
      current.fill_form(PRICES)
      current.add_input
      current.fill_input('freeEntrance2', EXTRA_FREE_ENTRANCE)
      current.save_price_info
      current
    end

  end
end
