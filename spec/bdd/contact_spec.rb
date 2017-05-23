require 'spec_helper_bdd'
require_relative 'test_support/contact'
require_relative '../../app'

feature 'Contact view' do
  scenario 'shows info' do
    current = Page::Contact.new
    contact = {
      'phone' => 'some phome',
      'email' => 'some email',
      'web' => 'some web'
    }

    current.fill_fields(contact)
    current.save_contact_info

    expect(current.has_info?(contact['phone'])).to be true
  end
end
