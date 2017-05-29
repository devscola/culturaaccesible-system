require 'spec_helper_bdd'
require_relative 'test_support/contact'
require_relative '../../app'
require_relative 'test_support/fixture_contact'

feature 'Contact' do
  let(:current) { Fixture.contact_form_shown }   

  scenario 'disallows submit without enough content' do
    result = current.button_enabled?('.submit')
    expect(result).to be false
  end

  scenario 'enables submit with enough content' do
    current.fill_with_enough_content

    result = current.button_enabled?('.submit')
    expect(result).to be true
  end

  scenario 'disallows add input without enough content' do
    result = current.button_enabled?('.phone')
    expect(result).to be false
  end

  scenario 'enables add input with enough content' do
    current.fill_with_enough_content

    result = current.button_enabled?('.phone')
    expect(result).to be true
  end

  scenario 'adds another input of the same type', :wip do
    current.fill_with_enough_content

    current.add_input

    expect(current.has_extra_input?). to be true
  end

  scenario 'view shows info with extra inputs' do
    current = Fixture.contact_form_filled_with_extra_inputs

    expect(current.has_info?(Fixture::CONTACT['phone'])).to be true
    expect(current.has_info?(Fixture::EXTRA_PHONE)).to be true
  end

end
