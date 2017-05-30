require 'spec_helper_bdd'
require_relative 'test_support/location'
require_relative '../../app'

feature 'Location' do
  scenario 'form hides when submitted' do
    current = Page::Location.new
    location = {
        'street' => 'some street',
        'postal' => 'some cp',
        'city' => 'some city',
        'region' => 'some region',
        'link' => 'https://goo.gl/maps/6fsENcN6uU12',
    }

    current.fill_form(location)
    current.save

    expect(current.has_form?).to be false
  end
end
