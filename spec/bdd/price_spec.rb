require 'spec_helper_bdd'
require_relative 'test_support/price'
require_relative '../../app'

feature 'Price view' do
  scenario 'shows prices' do
    current = Page::Price.new
    prices = fake_data

    current.fill_fields(prices)
    current.save_price_info

    expect(current.has_info?(prices['free_entrance'])).to be true
  end

  scenario 'shows edited last filled input' do
    current = Page::Price.new
    ANOTHER_FREE_ENTRANCE = 'parents'
    prices = fake_data

    current.fill_fields(prices)
    current.fill('freeEntrance1', ANOTHER_FREE_ENTRANCE)
    current.save_price_info

    expect(current.view_shows_info?(ANOTHER_FREE_ENTRANCE)).to be true
  end

  def fake_data
    prices = {
      'free_entrance' => 'children',
      'general' => '3€ for adults',
      'reduced' => ''
    }
    return prices
  end
end
