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

  scenario 'check if an exhibition name is in form item' do
    current = Fixture::Exhibitions.pristine.exhibition_saved
    exhibition_name = current.first_exhibition_name

    current.click_plus_button

    expect(has_content?(exhibition_name)).to be true
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
    save_screenshot('s1.png')

    current = Page::Exhibitions.new
    save_screenshot('s2.png')
    current.click_plus_button

    current = Page::Item.new

    current.fill('name',Fixture::Item::ARTWORK)
    current.fill('number',Fixture::Item::REPEATED_NUMBER)
    save_screenshot('s3.png')

    expect(current.submit_disabled?).to be true

  end
end
