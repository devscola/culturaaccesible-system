require 'spec_helper_bdd'
require_relative 'test_support/item'
require_relative 'test_support/fixture_item'

feature 'Item' do
  scenario 'allows type only four character on date' do
    current = Fixture::Item.initial_state

    current.fill('date','19865')

    expect(current.type_max_four_characters).to be true
  end
end
