module Page
  class Price
    include Capybara::DSL

    def initialize
      url = '/price'
      visit(url)
      validate!
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
