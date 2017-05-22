module Page
  class Info
    include Capybara::DSL

    def initialize
      url = '/info.html'
      visit(url)
      validate!
    end

    def has_save_button?
      has_css?('#save')
    end

    def fill(field, content)
      fill_in(field, with: content)
    end

    def save
      find('.submit').click
    end

    private

    def validate!
      page.assert_selector('#formulary')
    end
  end
end
