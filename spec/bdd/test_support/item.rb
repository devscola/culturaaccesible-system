module Page
  class Item
    include Capybara::DSL

    def initialize
      url = '/item'
      visit(url)
      validate!
    end

    def fill(name, content)
      fill_in(name, with: content)
    end

    def type_max_four_characters
      date_length = find('[name=date]').value.length
      (date_length <= 4)
    end

    private

    def validate!
      assert_selector('#formulary')
    end
  end
end
