require 'spec_helper_bdd'
require_relative 'test_support/location'
require_relative '../../app'

feature 'Location' do
  scenario 'view shows info', :wip do
    current = Page::Location.new
    location = {
        'street' => 'some street',
        'postal' => 'some postal',
        'city' => 'some city',
        'region' => 'some region',
        'link' => 'https://goo.gl/maps/6fsENcN6uU12',
    }
    current.fill_form(location)
    current.save
    result = current.has_info?('some city')

    expect(result).to be true
  end
end
