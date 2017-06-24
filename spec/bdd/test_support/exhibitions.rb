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
      find('.submit.cuac-exhibition-form').click
    end

    def click_edit
      find('.edit-button', wait: 4).click
    end

    def view_visible?
      view = find('.view', visible: false)
      view.visible?
    end

    def form_visible?
      form = find('.form', visible: false)
      form.visible?
    end

    def exhibition_list?
      has_css?('.list-item.cuac-exhibition-detail', wait: 2)
    end

    def form_submit_deactivated?
      has_css?('.submit[disabled].cuac-exhibition-form')
    end

    def other_name?
      has_css?('.list-item', text: 'some other name', wait: 2)
    end

    def click_plus_button
      first('.plus-button').click
    end

    def title(name)
      page.has_title?(name)
    end

    def has_edit_button?
      has_css?('.edit-button')
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
