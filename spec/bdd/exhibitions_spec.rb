require 'spec_helper_bdd'
require_relative 'test_support/exhibitions'
require_relative 'test_support/fixture_exhibitions'
require_relative 'test_support/exhibition_info'

feature 'item list' do
  before(:all) do
    Fixture::XExhibitions.pristine.complete_scenario
  end

  scenario 'shows each room with + button' do
    current = Page::Exhibitions.new
    current.toggle_list

    expect(current.room_have_plus_button?).to be true
  end

  scenario 'shows each sub-scene without + button' do
    current = Page::Exhibitions.new
    current.toggle_list

    expect(current.subscene_has_plus_button?).to be false
  end

  scenario 'shows list sorted by creation date'  do
    current = Page::Exhibitions.new

    expect(current.second_exhibition_shown?).to be true
  end

  scenario 'links to create item page' do
    current = Page::Exhibitions.new

    current.click_plus_button

    expect(current.title(Fixture::XExhibitions::REDIRECTED_PAGE_TITLE)).to be true
  end

  scenario 'shows sidebar in all exhibitions pages' do
    current = Page::Exhibitions.new
    expect(current.has_sidebar?).to be true

    current.go_to_exhibition_info

    expect(current.has_sidebar?).to be true
  end
end

feature 'create exhibitions' do
  before(:all) do
    Fixture::XExhibitions.pristine
  end

  scenario 'allows submit when required fields filled' do
    current = Page::Exhibitions.new

    current.fill_mandatory_fields

    expect(current.form_submit_deactivated?).to be false
  end

  context 'exhibition created', :woop do
    before(:all) do
      Fixture::XExhibitions.pristine
    end

    let(:current) { Page::Exhibitions.new.create_one }

    scenario 'displays editable info' do
      expect(current.view_visible?).to be true
      expect(current.form_visible?).to be false
      expect(current.has_edit_button?).to be true
    end

    scenario 'displays form when edit' do
      current.click_edit
      expect(current.view_visible?).to be false
      expect(current.form_visible?).to be true
    end

    scenario 'added link shows an image' do
      current.go_to_exhibition_info
      Page::ExhibitionInfo.new

      expect(page).to have_xpath("//img[contains(@src,'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg')]" )
    end
  end
end

feature 'updates' do
  scenario 'exhibition info' do
    current = Page::Exhibitions.new
    current.create_one
    current.edit_exhibition

    current.save

    expect(current.other_name?).to be true
  end
end
