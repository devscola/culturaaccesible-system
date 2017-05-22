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

    def has_textbox?
      has_css?('#description')
    end

    def has_field?
      has_css?('#name')
    end

    private

    def validate!
      page.assert_selector('#info-form')
    end
  end
end
