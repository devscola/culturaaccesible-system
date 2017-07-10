require 'spec_helper_bdd'
require_relative 'test_support/item'
require_relative 'test_support/fixture_item'
require_relative 'test_support/exhibitions'
require_relative 'test_support/fixture_exhibitions'

feature 'Item' do
  scenario 'allows submit when fill required name' do
    current = Fixture::Item.from_exhibition_to_new_item
    expect(current.submit_disabled?).to be true

    current.fill('name',Fixture::Item::ARTWORK)

    expect(current.submit_disabled?).to be false
  end

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

  scenario 'displays an alert when author or date are filled and room checkbox is typed' do
    current = Fixture::Item.shows_room_alert

    expect(current.alert_displayed?).to be true
  end

  scenario 'disallows to fill author and date when alert is accepted' do
    current = Fixture::Item.shows_room_alert


    current.accept_alert

    expect(current.room_checked?).to be true
    expect(current.input_blank?('author')).to be true
    expect(current.input_blank?('date')).to be true
    expect(current.input_disabled?('author')).to be true
    expect(current.input_disabled?('date')).to be true
  end

  scenario 'allows to fill author and date when alert is canceled' do
    current = Fixture::Item.shows_room_alert

    current.cancel_alert

    expect(current.room_checked?).to be false
    expect(current.input_disabled?('author')).to be false
    expect(current.input_disabled?('date')).to be false
  end

  scenario 'disallows to fill author and date' do
    current = Fixture::Item.from_exhibition_to_new_item

    expect(current.input_disabled?('author')).to be false
    expect(current.input_disabled?('date')).to be false

    current.check_room

    expect(current.input_disabled?('author')).to be true
    expect(current.input_disabled?('date')).to be true
  end

  scenario 'check if an exhibition name is in breadcrumb' do
    current = Fixture::Exhibitions.pristine.exhibition_saved
    exhibition_name = current.first_exhibition_name

    current.click_plus_button

    current = Page::Item.new

    expect(current.content?(exhibition_name)).to be true
  end

  scenario 'valid for submit if item number is validated' do
    current = Fixture::Item.from_exhibition_to_new_item

    current.fill('name',Fixture::Item::ARTWORK)
    current.fill('number',Fixture::Item::FIRST_NUMBER)

    current.submit

    current = Page::Exhibitions.new
    current.click_plus_button

    current = Page::Item.new

    current.fill('name',Fixture::Item::ARTWORK)
    current.fill('number',Fixture::Item::SECOND_NUMBER)

    expect(current.submit_disabled?).to be false
  end

  scenario 'invalid for submit if item number is not validated' do
    current = Fixture::Item.from_exhibition_to_new_item

    current.fill('name',Fixture::Item::ARTWORK)
    current.fill('number',Fixture::Item::FIRST_NUMBER)

    current.submit

    current = Page::Exhibitions.new
    current.click_plus_button

    current = Page::Item.new

    current.fill('name',Fixture::Item::ARTWORK)
    current.fill('number',Fixture::Item::REPEATED_NUMBER)

    expect(current.submit_disabled?).to be true
  end

  scenario 'save room when submit' do
    current = Fixture::Item.from_exhibition_to_new_item

    current.check_room
    current.fill('name',Fixture::Item::ARTWORK)
    current.fill('number',Fixture::Item::FIRST_NUMBER)

    current.submit

    expect(current.content?(Fixture::Item::VISIBLE_ARTWORK)).to be true
  end

  scenario 'add item to a room' do
    current = Fixture::Item.from_exhibition_to_new_item

    current.check_room
    current.fill('name',Fixture::Item::ARTWORK)
    current.fill('number',Fixture::Item::FIRST_NUMBER)

    current.submit

    current = Page::Exhibitions.new
    current.click_room_plus_button

    current = Page::Item.new

    expect(current.room_check_disabled?).to be true

    current.fill('name',Fixture::Item::OTHER_ARTWORK)
    current.fill('number',Fixture::Item::SECOND_NUMBER)

    current.submit

    expect(current.content?(Fixture::Item::VISIBLE_OTHER_ARTWORK)).to be true
  end

  scenario 'check if item name is in breadcrumb when it is saved' do
    current = Fixture::Exhibitions.pristine.exhibition_saved
    exhibition_name = current.first_exhibition_name
    breadcrumb =  exhibition_name + ' > ' + Fixture::Item::ARTWORK

    current.click_plus_button
    current_item = Fixture::Item.initial_state

    current_item.fill('name',Fixture::Item::ARTWORK)
    current_item.submit

    expect(has_content?(breadcrumb)).to be true
  end

  scenario 'click edit button' do
    current = Fixture::Exhibitions.pristine.exhibition_saved
    exhibition_name = current.first_exhibition_name
    breadcrumb =  exhibition_name + ' > ' + Fixture::Item::ARTWORK
    current = Fixture::Item.from_exhibition_to_new_item
    current.fill('name',Fixture::Item::ARTWORK)
    current.fill('number',Fixture::Item::FIRST_NUMBER)
    current.submit

    current.click_edit

    expect(has_content?(breadcrumb)).to be true
    expect(current.form_visible?).to be true
  end

  scenario 'show breadcrumb in edit' do
    current = Fixture::Exhibitions.pristine.exhibition_saved
    exhibition_name = current.first_exhibition_name
    breadcrumb =  exhibition_name + ' > ' + Fixture::Item::ARTWORK
    current = Fixture::Item.from_exhibition_to_new_item
    current.fill('name',Fixture::Item::ARTWORK)
    current.fill('number',Fixture::Item::FIRST_NUMBER)
    current.submit

    current.click_edit

    expect(has_content?(breadcrumb)).to be true
  end

  scenario 'updates item info' do
    current = Fixture::Item.from_exhibition_to_new_item
    current.fill('name',Fixture::Item::ARTWORK)
    current.fill('number',Fixture::Item::FIRST_NUMBER)
    current.submit

    current.click_edit
    current.fill('name',Fixture::Item::OTHER_ARTWORK)
    current.submit

    expect(current.other_name?).to be true
  end

end
