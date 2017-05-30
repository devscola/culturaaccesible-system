module Page
  class Location
    include Capybara::DSL

    def initialize
      url = '/location'
      visit(url)
      validate!
    end

    private

    def validate!
      assert_selector('#formulary')
    end
  end
end
