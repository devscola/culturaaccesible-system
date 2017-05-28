module Page
  class Contact
    include Capybara::DSL

    def initialize
      url = '/contact'
      visit(url)
      validate!
    end

    def has_info?(phone)
      has_content?(phone)
    end

    def fill_fields(contact)
      fill_in('phone', with: contact['phone'])
      fill_in('email', with: contact['email'])
      fill_in('web', with: contact['web'])
    end

    def save_contact_info
      find('.submit').click
    end

    private

    def validate!
      assert_selector('#formulary')
    end
  end
end
