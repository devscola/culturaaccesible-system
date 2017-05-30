require 'spec_helper_bdd'
require_relative 'test_support/location'
require_relative '../../app'

feature 'Location' do
  scenario 'page exists' do
    current = Page::Location.new

    expect(current).to be_a Page::Location
  end
end
