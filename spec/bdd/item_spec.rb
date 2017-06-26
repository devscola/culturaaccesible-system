require 'spec_helper_bdd'
require_relative 'test_support/item'
require_relative 'test_support/fixture_item'

feature 'Item', :wip do
  scenario 'allows type only four character on date' do
    current = Fixture::Item.initial_state

    current.fill('date','19865')

    expect(current.type_max_four_characters).to be true
  end

  scenario 'shows data inserted' do
    current = Fixture::Item.initial_state

    current.fill('name','Guernica')

    current.submit

    expect(current.content?('Name: Guernica')).to be true
  end

  scenario 'disallows to fill author and date' do
    current = Fixture::Item.initial_state

    expect(current.input_visible?('author')).to be true
    expect(current.input_visible?('date')).to be true    

    current.check_room

    expect(current.input_visible?('author')).to be false
    expect(current.input_visible?('date')).to be false
  end
end
