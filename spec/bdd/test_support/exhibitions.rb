module Page
  class Exhibitions
    include Capybara::DSL

    def initialize
      url = '/home'
      visit(url)
      validate!
    end

    def fill(field, content)
      fill_in(field, with: content)
    end


    def form_submit_deactivated?
      button = find('.submit')
      button.disabled?
    end

    def show
      find('#action').click
    end

    def save
      find('.submit').click
    end

    def exhibition_panel_visible?
      form = find('#result', visible: false)
      form.visible?
    end

    def exhibition_form_visible?
      form = find('#formulary', visible: false)
      form.visible?
    end

    def exhibition_list?
      has_css?('.list-item', wait: 2)
    end

    def form_submit_deactivated?
      has_css?('.submit[disabled]')
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
