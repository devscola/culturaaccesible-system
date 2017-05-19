require 'spec_helper_bdd'
require_relative 'test_support/contact'
require_relative '../../app'

feature 'Contact view' do
  scenario 'shows info' do
    page = Page::Contact.new
    contact = {
      'phone' => '963456456',
      'email' => 'fake@mail.com',
      'web' => 'webfake.com'
    }

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
