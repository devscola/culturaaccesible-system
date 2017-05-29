module Page
  class Price
    include Capybara::DSL

    def initialize
      url = '/price'
      visit(url)
      validate!
    end

    def has_info?(free_entrance)
      has_content?(free_entrance)
    end

    def view_shows_info?(value)
      has_content?(value)
    end

    def fill_fields(prices)
      fill_in('freeEntrance', with: prices['free_entrance'])
      fill_in('general', with: prices['general'])
      fill_in('reduced', with: prices['reduced'])
    end

    def fill(field, content)
      fill_in(field, with: content)
    end

    def save_price_info
      find('.submit').click
    end

    private

    def validate!
      assert_selector('#formulary')
    end
  end
end
