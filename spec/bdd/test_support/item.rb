module Page
  class Item
    include Capybara::DSL

    def initialize
      url = '/item'
      visit(url)
      validate!
    end

    private

    def validate!
      assert_selector('#item')
    end
  end
end
