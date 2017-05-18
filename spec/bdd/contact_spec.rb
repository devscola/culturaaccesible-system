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
