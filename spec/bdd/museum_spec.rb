require 'spec_helper_bdd'
require_relative 'test_support/museum'

feature 'Museum' do
  scenario 'page renders' do
    result = Page::Museum.new

    expect(result).to be_a Page::Museum
  end
end
