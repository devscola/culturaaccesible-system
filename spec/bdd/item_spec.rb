require 'spec_helper_bdd'
require_relative 'test_support/fixture_museum'
require_relative 'test_support/fixture_exhibitions'
require_relative 'test_support/museum'
require_relative 'test_support/exhibitions'
require_relative 'test_support/fixture_item'
require_relative 'test_support/room_info'
require_relative 'test_support/scene_info'
require_relative 'test_support/item'

feature 'Item' do
  before(:all) do
    Fixture::Item.complete_scenario
  end

  scenario 'disallows to fill author and date when alert is accepted' do
    current = Page::Exhibitions.new
    current.click_plus_button
    current = Fixture::Item.create_a_room_with_alert
    current.accept_alert

    expect(current.room_checked?).to be true
    expect(current.input_blank?('author')).to be true
    expect(current.input_blank?('date')).to be true
    expect(current.input_disabled?('author')).to be true
    expect(current.input_disabled?('date')).to be true
  end

  scenario 'allows to fill author and date when alert is canceled' do
    current = Page::Exhibitions.new
    current.click_plus_button
    current = Fixture::Item.create_a_room_with_alert

    current.cancel_alert

    expect(current.room_checked?).to be false
    expect(current.input_disabled?('author')).to be false
    expect(current.input_disabled?('date')).to be false
  end

  scenario 'disallows to fill author and date' do
    current = Page::Exhibitions.new
    current.click_plus_button
    current = Page::Item.new

    expect(current.input_disabled?('author')).to be false
    expect(current.input_disabled?('date')).to be false

    current.check_room

    expect(current.input_disabled?('author')).to be true
    expect(current.input_disabled?('date')).to be true
  end

  scenario 'save room when submit' do
    current = Page::Exhibitions.new
    current.click_plus_button
    current = Page::Item.new

    current.check_room
    current.fill('name',Fixture::Item::ARTWORK)
    current.fill('number',Fixture::Item::THIRD_NUMBER)

    current.submit

    expect(current.content?(Fixture::Item::VISIBLE_ARTWORK)).to be true
  end

  scenario 'avoid create rooms in subscenes' do
    current = Page::SceneInfo.new
    current.toggle_list
    current.go_to_subscene_info
    current = Page::RoomInfo.new
    current.toggle_list

    current.click_item_plus_button

    expect(current.room_check_disabled?).to be true
  end

  scenario 'displays exhibition languages info in edited item view info' do

    current = Page::Exhibitions.new
    current.click_in_exhibition_plus_button
    current = Page::Item.new
    current.fill_room_form_with_languages
    current.submit

    current = Page::Exhibitions.new
    current.toggle_list
    current.go_to_last_room_info

    expect(current.content?('nombre de room')).to be true
    expect(current.content?('descripció de room')).to be true
    expect(current.content?('https://s3.amazonaws.com/pruebas-cova/more3minutes.mp4')).to be true

    current.click_edit
    current.fill('video-cat', 'https://s3.amazonaws.com/pruebas-cova/3minutes.mp4')
    current.submit
    current = Page::Exhibitions.new
    current.toggle_list
    current.go_to_last_room_info

    expect(current.find_content('.name-es')).to eq 'Name: nombre de room'
    expect(current.find_content('.description-cat')).to eq 'Description: descripció de room'
    expect(current.find_content('.video-cat')).to eq 'Video: https://s3.amazonaws.com/pruebas-cova/3minutes.mp4'
  end

  context 'pages is' do
    before :all do
      Fixture::Item.complete_scenario
    end

    scenario 'valid for submit if item number is validated' do
      current = Page::Exhibitions.new
      current.click_plus_button
      current = Page::Item.new

      current.fill('name',Fixture::Item::ARTWORK)
      current.fill('number',Fixture::Item::THIRD_NUMBER)

      current.submit

      current = Page::Exhibitions.new
      current.click_plus_button

      current = Page::Item.new

      current.fill('name',Fixture::Item::ARTWORK)
      current.fill('number',Fixture::Item::SECOND_NUMBER)

      expect(current.submit_disabled?).to be false
    end

    scenario 'invalid for submit if item number is not validated' do
      current = Page::Exhibitions.new
      current.click_plus_button
      current = Page::Item.new

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
  end

  context 'add item' do
    before :all do
      Fixture::Item.complete_scenario
    end

    scenario 'to a room' do
      current = Page::RoomInfo.new

      current.toggle_list

      expect(current.room_has_children?).to be true
    end

    scenario 'to a room has disabled checkbox' do
      current = Page::Exhibitions.new
      current.toggle_list
      current.click_room_plus_button
      current = Page::Item.new

      expect(current.room_check_disabled?).to be true
    end
  end

  context 'shows' do
    before :all do
      Fixture::Item.complete_scenario
    end

    scenario 'shows room info when room name is clicked' do
      current = Page::RoomInfo.new

      current.toggle_list
      current.go_to_room_info

      expect(current.content?(Fixture::Item::INFO_FIRST_NUMBER)).to be true
    end

    scenario 'shows scene info when scene name is clicked' do
      scene_number = '1-1-0'
      current = Page::SceneInfo.new

      current.toggle_list
      current.go_to_scene_info

      expect(current.content?(scene_number)).to be true
    end

    scenario 'shows subscene info when subscene name is clicked' do
      Fixture::Item.complete_scenario
      subscene_number = '1-1-1'
      current = Page::SceneInfo.new

      current.last_toggle_list
      current.go_to_subscene_info

      expect(current.content?(subscene_number)).to be true
    end
  end

  context 'lock checkbox' do
    before :all do
      Fixture::Item.complete_scenario
    end

    scenario 'when room is edited' do
      current = Page::RoomInfo.new
      current.toggle_list
      current.go_to_room_info
      current.click_edit

      expect(current.room_check_disabled?).to be true
    end

    scenario 'when scene is edited' do
      current = Page::SceneInfo.new
      current.toggle_list
      current.go_to_scene_info
      current.click_edit

      expect(current.room_check_disabled?).to be true
    end
  end

  context 'suggests' do
    before :all do
      Fixture::Item.complete_scenario
    end

    scenario 'next first order number' do
      next_number_in_scenario = '2-0-0'
      current = Page::Exhibitions.new
      current.click_plus_button
      current = Page::Item.new

      expect(current.find_suggested_number).to eq(next_number_in_scenario)
    end

    scenario 'next second order number' do
      next_number_in_scenario = '1-2-0'
      current = Page::Exhibitions.new

      current.toggle_list
      current.click_room_plus_button
      current = Page::Item.new

      expect(current.find_suggested_number).to eq(next_number_in_scenario)
    end
  end

  context 'creating' do
    before :all do
      Fixture::Item.complete_scenario
    end

    scenario 'an item requires name' do
      current = Page::Exhibitions.new
      current.click_plus_button
      current = Page::Item.new
      current.fill('name',Fixture::Item::ARTWORK)

      expect(current.submit_disabled?).to be false
    end

    scenario 'an item shows data inserted' do
      current = Page::Exhibitions.new
      current.click_plus_button
      current = Page::Item.new
      current.fill('name',Fixture::Item::ARTWORK)
      current.submit

      expect(current.content?(Fixture::Item::VISIBLE_ARTWORK)).to be true
    end

    scenario 'a room displays an alert when author or date are filled and room checkbox is typed' do
      Fixture::Item.complete_scenario
      current = Page::Exhibitions.new
      current.click_plus_button
      current = Fixture::Item.create_a_room_with_alert

      expect(current.alert_displayed?).to be true
    end
  end

  context 'fix' do
    before :all do
      Fixture::Item.complete_scenario
    end

    scenario 'add room when item fields are filled' do
      current = Page::Exhibitions.new
      current.click_plus_button
      current = Fixture::Item.create_a_room_with_alert
      current.accept_alert
      current.submit

      expect(current.content?(Fixture::Item::VISIBLE_ARTWORK)).to be true
      expect(current.content?(Fixture::Item::VISIBLE_AUTHOR)).to be false
    end

    scenario 'exhibitions edition when it has items' do
      current = Page::Exhibitions.new
      current.go_to_exhibition_info(Fixture::Exhibitions::NAME)
      current.click_edit
      current.fill('name', Fixture::Exhibitions::OTHER_NAME)
      current.select_museum(Fixture::Museum::FIRST_MUSEUM)
      current.save

      expect(current.has_toggle?).to be true

      current.toggle_list

      expect(current.exhibition_name(Fixture::Exhibitions::OTHER_NAME)).to eq(Fixture::Exhibitions::OTHER_NAME)
      expect(current.content?('room')).to be true
    end
  end
end
