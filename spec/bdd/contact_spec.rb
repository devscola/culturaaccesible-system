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

feature 'Contact form' do
  scenario 'has save button' do
    page = Page::Contact.new

    expect(page.has_save_button?).to be true
  end

  scenario 'has fields' do
    page = Page::Contact.new

    expect(page.has_fields?).to be true
  end
end
