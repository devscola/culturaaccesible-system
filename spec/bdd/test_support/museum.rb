module Page
  class Museum
    include Capybara::DSL

    def initialize
      url = '/museum'
      visit(url)
      validate!
    end

    private

    def validate!
      assert_selector('#formulary')
    end
  end
end
