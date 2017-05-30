require 'spec_helper_bdd'
require_relative 'test_support/price'
require_relative 'test_support/fixture_price'
require_relative '../../app'

feature 'Price' do
  let(:current) { Fixture.price_form_shown }

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
    result = current.button_enabled?('.freeEntrance')
    expect(result).to be false
  end

  scenario 'enables add input with enough content' do
    current.fill_with_enough_content

    result = current.button_enabled?('.freeEntrance')
    expect(result).to be true
  end

  scenario 'adds another input of the same type' do
    current.fill_with_enough_content

    current.add_input

    expect(current.has_extra_input?). to be true
  end

  scenario 'view shows prices with extra inputs' do
    current = Fixture.price_form_filled_with_extra_inputs

    expect(current.has_info?(Fixture::PRICES['freeEntrance1'])).to be true
    expect(current.has_info?(Fixture::EXTRA_FREE_ENTRANCE)).to be true
  end

  scenario 'shows edited input value' do
    current.fill_form(Fixture::PRICES)

    another_free_entrance = 'another free entrance'
    current.fill('freeEntrance1', another_free_entrance)
    current.save_price_info

    expect(current.has_info?(another_free_entrance)).to be true
  end
end
