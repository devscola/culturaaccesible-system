module Page
  class Exhibitions
    include Capybara::DSL

    def initialize
      url = '/home.html'
      visit(url)
      validate!
    end

    def exhibition_list?
      has_css?('.exhibition')
    end

    def fill(field, content)
      fill_in(field, with: content)
    end

    def form_submit_deactivated?
      has_css?('#submit-form[disabled]')
    end

    def show_exhibition_form
      find('#new-exhibition').click
    end

    def exhibition_form_visible?
      form = find('#exhibition-form', visible: false)
      form.visible?
    end

    private

    def validate!
      page.assert_selector('#exhibition-form', visible: false)
      page.assert_selector('#new-exhibition')
      page.assert_selector('#exhibitions-list', visible: false)
    end
  end
end