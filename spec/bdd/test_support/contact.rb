module Page
  class Contact
    include Capybara::DSL

    def initialize
      url = '/contact'
      visit(url)
      validate!
    end

    def save

    end

    def has_info?(phone)
      has_content?(phone)
    end

    def has_save_button?
      has_css?('#save')
    end

    def has_fields?
      has_css?('.field')
    end

    def fill_fields(contact)
      first(:css, 'input.Phone').native.send_keys(contact['phone'])

      input_email = first(:css, 'input.Email').native
      input_email.send_keys(contact['email'])

      input_web = first(:css, 'input.Web').native
      input_web.send_keys(contact['web'])
    end 

    def save_contact_info
      find('#save').click
    end 

    private

    def validate!
      page.assert_selector('#contact-view')
      page.assert_selector('#contact-form')
    end
  end
end
