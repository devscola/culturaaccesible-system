require 'spec_helper_bdd'
require_relative 'test_support/price'
require_relative '../../app'

xfeature 'Price view' do
  scenario 'shows prices' do
    current = Page::Price.new
    prices = {
      'free_entrance' => 'children',
      'general' => '3€ for adults',
      'reduced' => ''
    }

    current.fill_fields(prices)
    current.save_price_info

    expect(current.has_info?(prices['free_entrance'])).to be true
  end
end
