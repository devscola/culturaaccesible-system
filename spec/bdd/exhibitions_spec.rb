require 'spec_helper_bdd'
require_relative 'test_support/exhibitions'
require_relative 'test_support/fixture_exhibitions'

feature 'Exhibitions' do
  before(:each) do
    Exhibitions::Fixture.pristine
  end

  scenario 'has items' do
    current = Exhibitions::Fixture.exhibition_saved

    expect(current.exhibition_list?).to be true
  end

  scenario 'shows exhibition form' do
    current = Exhibitions::Fixture.show_exhibition_form

    expect(current.form_visible?). to be true
  end

  scenario 'allows submit when required fields filled' do
    current = Exhibitions::Fixture.fill_form

    expect(current.form_submit_deactivated?).to be false
  end

  scenario 'displays when form is submited' do
    current = Exhibitions::Fixture.exhibition_saved

    expect(current.view_visible?).to be true
  end

  scenario 'shows list sorted by creation date' do
    name = 'some name'
    other_name = 'some other name'
    current = Exhibitions::Fixture.two_exhibitions_introduced(name, other_name)

    result = current.first_element

    expect(result).to eq(name)
  end

  scenario 'shows link button' do
    name = 'some name'
    other_name = 'some other name'
    current = Exhibitions::Fixture.two_exhibitions_introduced(name, other_name)

    current.click_plus_button

    expect(current.title('Item')).to be true
  end

  scenario 'hide exhibition form' do
    current = Exhibitions::Fixture.exhibition_saved

    expect(current.form_visible?).to be false
  end

  scenario 'shows edit button' do
    current = Exhibitions::Fixture.exhibition_saved

    expect(current.has_edit_button?).to be true
  end

  scenario 'hides view when edit' do
    current = Exhibitions::Fixture.exhibition_saved

    current.click_edit

    expect(current.view_visible?).to be false
  end

  scenario 'shows form when edit' do
    current = Exhibitions::Fixture.exhibition_saved

    current.click_edit

    expect(current.form_visible?).to be true
  end

  scenario 'updates exhibition info' do
    current = Exhibitions::Fixture.exhibition_edited

    current.save

    expect(current.first_element).to eq 'some updated name'
  end
end
