require 'spec_helper_bdd'
require_relative 'test_support/item'
require_relative 'test_support/fixture_item'
require_relative 'test_support/exhibitions'
require_relative 'test_support/fixture_exhibitions'
require_relative 'test_support/room_info'
require_relative 'test_support/scene_info'

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

  scenario 'suggests next first order number' do
    current = Fixture::Item.from_exhibition_to_new_item

    current.fill('name',Fixture::Item::ARTWORK)
    result = current.find_suggested_number

    expect(result).to eq('1.0.0')
  end

  scenario 'suggests next second order number' do
    Fixture::Item.from_exhibition_to_new_item
    Fixture::Item.room_saved
    current = Page::Exhibitions.new
    current.toggle_list
    current.click_room_plus_button
    current = Page::Item.new

    current.fill('name',Fixture::Item::OTHER_ARTWORK)
    result = current.find_suggested_number

    expect(result).to eq('1.1.0')
  end

  scenario 'save room when submit' do
    current = Fixture::Item.from_exhibition_to_new_item

    current.check_room
    current.fill('name',Fixture::Item::ARTWORK)
    current.fill('number',Fixture::Item::FIRST_NUMBER)

    current.submit

    expect(current.content?(Fixture::Item::VISIBLE_ARTWORK)).to be true
  end

  scenario 'add item to a room has disabled checkbox' do
    Fixture::Item.from_exhibition_to_new_item

    Fixture::Item.room_saved

    current = Page::Exhibitions.new

    current.toggle_list

    current.click_room_plus_button

    current = Page::Item.new

    expect(current.room_check_disabled?).to be true
  end

  scenario 'fix add room when item fields are filled' do
    Fixture::Item.from_exhibition_to_new_item

    current = Fixture::Item.item_filled

    current.check_room
    current.accept_alert

    current.submit

    expect(current.content?(Fixture::Item::VISIBLE_ARTWORK)).to be true
    expect(current.content?(Fixture::Item::VISIBLE_AUTHOR)).to be false
  end

  scenario 'add item to a room' do
    Fixture::Item.from_exhibition_to_new_item

    Fixture::Item.room_saved

    Fixture::Item.item_saved_in_room

    current = Page::Exhibitions.new
    current.toggle_list

    expect(current.room_has_children?).to be true
  end

  scenario 'shows room info when room name is clicked' do
    Fixture::Item.from_exhibition_to_new_item

    Fixture::Item.room_saved

    current = Page::Exhibitions.new
    current.toggle_list

    current.go_to_room_info

    current = Page::RoomInfo.new

    expect(current.content?(Fixture::Item::INFO_FIRST_NUMBER)).to be true
  end

  scenario 'shows scene info when scene name is clicked' do
    Fixture::Item.from_exhibition_to_new_item

    Fixture::Item.item_saved

    current = Page::Exhibitions.new
    current.toggle_list

    current.go_to_scene_info

    current = Page::SceneInfo.new

    expect(current.content?(Fixture::Item::INFO_SECOND_NUMBER)).to be true
  end

  scenario 'shows subscene info when subscene name is clicked' do
    Fixture::Item.from_exhibition_to_new_item

    Fixture::Item.item_saved

    Fixture::Item.item_saved_in_item

    current = Page::Exhibitions.new
    current.toggle_list

    current.go_to_subscene_info

    current = Page::SceneInfo.new

    expect(current.content?(Fixture::Item::INFO_THIRD_NUMBER)).to be true
  end

  scenario 'shows subscene info when subscene name from room > scene >subscene is clicked' do
    Fixture::Item.from_exhibition_to_new_item

    Fixture::Item.room_saved

    Fixture::Item.item_saved_in_room

    Fixture::Item.item_saved_in_item

    current = Page::Exhibitions.new
    current.toggle_list

    expect(current.scene_in_room_has_children?).to be true

    current.go_to_last_subscene_info

    current = Page::SceneInfo.new


    expect(current.content?(Fixture::Item::INFO_THIRD_NUMBER)).to be true
  end

  scenario 'add item to an item' do
    Fixture::Item.from_exhibition_to_new_item

    Fixture::Item.item_saved

    Fixture::Item.item_saved_in_item

    current = Page::Exhibitions.new
    current.toggle_list

    expect(current.scene_has_children?).to be true
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
