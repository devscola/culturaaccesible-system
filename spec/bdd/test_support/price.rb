module Page
  class Price
    include Capybara::DSL
    def initialize
      url = '/price'
      visit(url)
      validate!
    end

    private

    def validate!
      assert_selector('#formulary', visible: false)
    end
  end
end
