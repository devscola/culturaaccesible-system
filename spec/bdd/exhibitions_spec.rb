require 'spec_helper_bdd'
require_relative 'test_support/exhibitions'
require_relative 'test_support/fixture_exhibitions'

feature 'Exhibitions' do
  scenario 'has items' do
    current = Fixture::save_exhibition

    expect(current.exhibition_list?).to be true
  end

  scenario 'shows exhibition form' do
    current = Fixture::show_exhibition_form

    expect(current.exhibition_form_visible?). to be true
  end

  scenario 'allows submit when required fields filled' do
    current = Fixture::fill_form

    expect(current.form_submit_deactivated?).to be false
  end

  scenario 'displays when form is submited' do
    current = Fixture::save_exhibition

    expect(current.exhibition_panel_visible?).to be true
  end

  scenario 'shows list sorted by creation date' do
    name = 'some name'
    other_name = 'some other name'
    current = Fixture.two_exhibitions_introduced(name, other_name)

    result = current.first_element

    expect(result).to eq(name)
  end
end
