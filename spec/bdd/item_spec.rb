require 'spec_helper_bdd'
require_relative 'test_support/item'
require_relative 'test_support/fixture_item'

feature 'Item' do
  scenario 'has page' do
    current = Page::Item.new

    expect(current).to be_a Page::Item
  end
end
