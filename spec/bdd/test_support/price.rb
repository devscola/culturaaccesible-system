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
      first(:css, 'input.free_entrance').native.send_keys(contact['free_entrance'])

      first(:css, 'input.general').native.send_keys(contact['general'])

      first(:css, 'input.reduced').native.send_keys(contact['reduced'])
    end

    def save_price_info
      find('.submit').click
    end

    def has_form?
      has_css?('.form', visible: true)
    end

    def fill(field, content)
      fill_in(field, with: content)
    end

    def save
      find('.submit').click
    end

    private

    def validate!
      assert_selector('#formulary')
    end
  end
end
