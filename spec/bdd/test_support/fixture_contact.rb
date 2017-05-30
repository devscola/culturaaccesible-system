require_relative 'contact'

class Fixture
  extend Capybara::DSL
  
  CONTACT = {
    'phone1' => 'some phone',
    'email1' => 'some email',
    'web1' => 'some web'
  }

  EXTRA_PHONE = 'extra phone'

  class << self
    def contact_form_shown
      Page::Contact.new
    end

    def contact_form_filled_with_extra_inputs
      current = contact_form_shown
      current.fill_form(CONTACT)
      current.add_input
      current.fill_input('phone2', EXTRA_PHONE)
      current.save_contact_info
      current
    end

  end
end
