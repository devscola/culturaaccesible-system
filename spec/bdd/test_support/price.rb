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

    def fill_fields(prices)
      fill_in('free_entrance', with: contact['free_entrance'])
      fill_in('general', with: contact['general'])
      fill_in('reduced', with: contact['reduced'])
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
