module Page
  class Contact
    include Capybara::DSL

    def initialize
      url = '/contact'
      visit(url)
      validate!
    end

    def has_info?(content)
      has_content?(content)
    end

    def fill_input(identifier, content)
      fill_in(identifier, with: content)
    end

    def fill_form(contact)
      contact.each do |identifier, content|
        fill_input(identifier, content)
      end
    end

    def fill(field, content)
      fill_in(field, with: content)
    end

    def save_contact_info
      find('.submit').click
    end

    def fill_with_enough_content
      enough_content = 'a'
      fill_in('phone1', with: enough_content)
    end

    def button_enabled?(css_class)
      button = find(css_class)
      result = button[:disabled]

      return true if result.nil?

      false
    end

    def add_input
      find('.phone').click
    end

    def has_extra_input?
      inputs = all("input[name^='phone']")
      inputs.size > 1
    end

    private

    def validate!
      assert_selector('#formulary')
    end
  end
end
