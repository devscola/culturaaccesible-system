module Page
  class Museum
    include Capybara::DSL

    def initialize
      url = '/museum'
      visit(url)
      validate!
    end

    def fill_input(field, content)
      fill_in(field, with: content)
    end

    private

    def validate!
      assert_selector('#formulary')
    end
  end
end
