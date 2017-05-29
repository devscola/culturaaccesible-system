require 'spec_helper_bdd'
require_relative 'test_support/contact'
require_relative '../../app'

feature 'Contact view' do
  scenario 'shows info' do
    current = Page::Contact.new
    contact = fake_data

    current.fill_fields(contact)
    current.save_contact_info

    expect(current.has_info?(contact['phone'])).to be true
  end
  scenario 'shows edited last filled input' do
    current = Page::Contact.new
    ANOTHER_PHONE = 'another phone'
    contact = fake_data

    current.fill_fields(contact)
    current.fill('phone', ANOTHER_PHONE)
    current.save_contact_info

    expect(current.view_shows_info?(ANOTHER_PHONE)).to be true
  end

  def fake_data
    contact = {
      'phone' => 'some phome',
      'email' => 'some email',
      'web' => 'some web'
    }
    return contact
  end
end
