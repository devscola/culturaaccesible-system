require 'spec_helper_bdd'
require_relative 'test_support/price'
require_relative '../../app'

feature 'Price form' do
  scenario 'form hide when submitted' do
    current = Page::Info.new
    current.fill('free_entrance', 'children')
    current.fill('general', '5€')
    current.save

    expect(current.has_form?).to be false
  end
end
