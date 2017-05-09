module Page
  class Exhibitions
    include Capybara::DSL

    def initialize
      url = '/home.html'
      visit(url)
      validate!
    end

    def fill(field, content)
      fill_in(field, with: content)
    end

    def form_submit_deactivated?
      has_css?('#submit-form[disabled]')
    end

    private

    def validate!
      page.assert_selector('#exhibition-form')
      page.assert_selector('#submit-form[disabled]')
    end
  end
end
