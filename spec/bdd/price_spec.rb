require 'spec_helper_bdd'
require_relative 'test_support/price'
require_relative '../../app'

feature 'Price' do
  scenario 'page exists' do
    price = Page::Price.new

    expect(price).to be_a Page::Price
  end
end
