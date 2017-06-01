require 'spec_helper_bdd'
require_relative 'test_support/fixture_museum'
require_relative 'test_support/museum'

feature 'Museum' do
  scenario 'allows submit when enough content' do
    current = Fixture::Museum.enough_content
    expect(current.save_enabled?).to be true
  end

  xscenario 'disallows submit after enough content removed', :wip do
    current = Fixture::Museum.enough_content
    current.remove_field_content

    expect(current.save_enabled?).to be false
  end
end

feature 'Museum contact' do
  let(:current) { Fixture::Museum.contact_form_shown }

  scenario 'disallows add input without enough content' do
    result = current.button_enabled?('.phone')
    expect(result).to be false
  end

  scenario 'enables add input with enough content' do
    current.fill_with_enough_content

    result = current.button_enabled?('.phone')
    expect(result).to be true
  end

  scenario 'adds another input of the same type' do
    current.fill_with_enough_content

    current.add_input

    expect(current.has_extra_input?).to be true
  end
end
