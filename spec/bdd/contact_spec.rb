require 'spec_helper_bdd'
require_relative 'test_support/contact'
require_relative '../../app'

feature 'Contact view' do
  scenario 'shows info' do
    page = Page::Contact.new
    contact = {
      'phone' => 'some phome',
      'email' => 'some email',
      'web' => 'some web'
    }

    page.fill_fields(contact)
    page.save_contact_info

    expect(page.has_info?(contact['phone'])).to be true
  end
end
