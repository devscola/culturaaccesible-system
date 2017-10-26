module Page
  class Login
    include Capybara::DSL

    def initialize
      url = '/'
      visit(url)
      validate!
    end

    def fill(name, content)
      fill_in(name, with: content)
    end

    def content?(content)
      has_content?(content, wait: 1)
    end

    def submit
      find('.submit').click
    end

    private

    def validate!
      assert_selector('#login')
      assert_selector('#username')
      assert_selector('#password')
      assert_selector(".submit")
    end
  end
end
