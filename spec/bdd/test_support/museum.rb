module Page
  class Museum
    include Capybara::DSL

    def initialize
      url = '/museum'
      visit(url)
      validate!
    end

    def click_new_museum
      find('#newMuseum').click
    end

    def has_form?
      has_css?('#formulary')
    end

    def fill_input(field, content)
      fill_in(field, with: content)
    end

    def save_enabled?
      button = find('#action')
      result = button[:disabled]

      return true if result.nil?

      false
    end

    def submit
      find('#action').click
    end

    def shows_info?
      has_css?('.view')
    end

    def fill_form(contact)
      contact.each do |identifier, content|
        fill_input(identifier, content)
      end
    end

    def add_input
      find('.phone').click
    end

    def button_enabled?(css_class)
      button = find(css_class)
      result = button[:disabled]

      return true if result.nil?

      false
    end

    def fill_with_enough_content
      enough_content = 'a'
      fill_in('phone1', with: enough_content)
    end

    def has_extra_input?(actual_inputs = 1)
      inputs = all("input[name^='phone']")
      inputs.size > actual_inputs
    end

    def fill_any_input_except_last_one
      fill_input('phone1', '666')
      add_input
      fill_input('phone1', '')
      fill_input('phone1', '666')
    end

    def remove_field_content
      fill_in('link', with: '')
    end

    private

    def validate!
      assert_selector('#newMuseum')
      assert_selector('#formulary', visible: false)
    end
  end
end
