module Page
  class Item
    include Capybara::DSL

    def initialize
      url = '/item/:id'
      visit(url)
      validate!
    end

    def fill(name, content)
      fill_in(name, with: content)
    end

    def content?(content)
      has_content?(content)
    end

    def submit
      find('[name=submit]').click
    end

    def type_max_four_characters
      date_length = find('[name=date]').value.length
      (date_length <= 4)
    end

    def check_room
      find_field(name: 'room').click
    end

    def input_visible?(field)
      has_css?("input[name=#{field}]")
    end

    private

    def validate!
      assert_selector('#formulary')
      assert_selector("input[name='name']", visible: false)
    end
  end
end
