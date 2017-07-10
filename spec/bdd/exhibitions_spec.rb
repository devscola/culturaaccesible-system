require 'spec_helper_bdd'
require_relative 'test_support/exhibitions'
require_relative 'test_support/fixture_exhibitions'
require_relative 'test_support/exhibition_info'


feature 'Exhibitions' do
  before(:each) do
    Fixture::Exhibitions.pristine
  end

  scenario 'has items' do
    current = Fixture::Exhibitions.exhibition_saved

    expect(current.exhibition_list?).to be true
  end

  scenario 'shows a list of rooms' do
    current = Fixture::Exhibitions.exhibition_saved_with_room

    expect(current.list_has_rooms?).to be true
  end

  scenario 'shows a list of items' do
    current = Fixture::Exhibitions.exhibition_saved_with_item

    expect(current.list_has_scenes?).to be true
  end

  scenario 'shows each room with + button' do
    current = Fixture::Exhibitions.exhibition_saved_with_room

    expect(current.room_have_plus_button?).to be true
  end

  scenario 'shows exhibition form' do
    current = Fixture::Exhibitions.show_exhibition_form

    expect(current.form_visible?). to be true
  end

  scenario 'allows submit when required fields filled' do
    current = Fixture::Exhibitions.fill_form

    expect(current.form_submit_deactivated?).to be false
  end

  scenario 'displays when form is submited' do
    current = Fixture::Exhibitions.exhibition_saved

    expect(current.view_visible?).to be true
  end

  scenario 'shows list sorted by creation date'  do
    current = Fixture::Exhibitions.two_exhibitions_introduced

    expect(current.other_name?).to be true
  end

  scenario 'shows link button' do
    current = Fixture::Exhibitions.two_exhibitions_introduced

    current.click_plus_button

    expect(current.title(Fixture::Exhibitions::REDIRECTED_PAGE_TITLE)).to be true
  end

  scenario 'hide exhibition form' do
    current = Fixture::Exhibitions.exhibition_saved

    expect(current.form_visible?).to be false
  end

  scenario 'shows edit button' do
    current = Fixture::Exhibitions.exhibition_saved

    expect(current.has_edit_button?).to be true
  end

  scenario 'hides view when edit' do
    current = Fixture::Exhibitions.exhibition_saved

    current.click_edit

    expect(current.view_visible?).to be false
  end

  scenario 'shows form when edit' do
    current = Fixture::Exhibitions.exhibition_saved

    current.click_edit

    expect(current.form_visible?).to be true
  end

  scenario 'updates exhibition info' do
    current = Fixture::Exhibitions.exhibition_edited

    current.save

    expect(current.other_name?).to be true
  end

  scenario 'shows exhibition info when exhibition name is clicked' do
    current = Fixture::Exhibitions.exhibition_saved
    current.go_to_exhibition_info

    current = Page::ExhibitionInfo.new

    expect(current.content?(Fixture::Exhibitions::EXHIBITION_NAME)).to be true
  end
end
