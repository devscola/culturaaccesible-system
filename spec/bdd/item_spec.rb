require 'spec_helper_bdd'
require_relative 'test_support/item'
require_relative 'test_support/fixture_item'
require_relative 'test_support/exhibitions'
require_relative 'test_support/fixture_exhibitions'

feature 'Item' do
  scenario 'allows type only four character on date' do
    current = Fixture::Item.from_exhibition_to_new_item

    current.fill('date',Fixture::Item::ERROR_LENGTH_DATE)

    expect(current.type_max_four_characters).to be true
  end

  scenario 'shows data inserted' do
    current = Fixture::Item.from_exhibition_to_new_item

    current.fill('name',Fixture::Item::ARTWORK)
    current.submit

    expect(current.content?(Fixture::Item::VISIBLE_ARTWORK)).to be true
  end

  scenario 'disallows to fill author and date' do
    current = Fixture::Item.from_exhibition_to_new_item

    expect(current.input_visible?('author')).to be true
    expect(current.input_visible?('date')).to be true

    current.check_room

    expect(current.input_visible?('author')).to be false
    expect(current.input_visible?('date')).to be false
  end

  scenario 'check if an exhibition name is in form item' do
    current = Fixture::Exhibitions.pristine.exhibition_saved
    exhibition_name = current.first_exhibition_name

    current.click_plus_button
    
    expect(has_content?(exhibition_name)).to be true
  end
end
