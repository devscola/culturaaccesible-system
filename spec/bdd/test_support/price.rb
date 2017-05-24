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
      first(:css, 'input.free-entrance').native.send_keys(prices['free_entrance'])

      first(:css, 'input.general').native.send_keys(prices['general'])

      first(:css, 'input.reduced').native.send_keys(prices['reduced'])
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
