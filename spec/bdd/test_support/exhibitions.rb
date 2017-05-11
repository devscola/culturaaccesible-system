module Page
  class Exhibitions
    include Capybara::DSL

    def initialize
      url = '/home.html'
      visit(url)
      validate!
    end

    def exhibition_list?
      has_css?('.list-item')
    end

    def fill(field, content)
      fill_in(field, with: content)
    end

    def form_submit_deactivated?
      has_css?('#submit-form[disabled]')
    end

    def show_exhibition_form
      find('#action button').click
    end

    def save_exhibition
      find('#submit-form').click
    end

    def exhibition_panel_visible?
      form = find('#result', visible: false)
      form.visible?
    end

    def exhibition_form_visible?
      form = find('#formulary', visible: false)
      form.visible?
    end

    private

    def validate!
      page.assert_selector('#formulary', visible: false)
      page.assert_selector('#action')
      page.assert_selector('#listing', visible: false)
      page.assert_selector('#result', visible: false)
    end
  end
end
