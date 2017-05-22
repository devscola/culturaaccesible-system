require 'spec_helper_bdd'
require_relative 'test_support/info'
require_relative '../../app'

feature 'Info form' do
  scenario 'has save button' do
    page = Page::Info.new

    expect(page.has_save_button?).to be true
  end
  scenario 'has textarea' do
    page = Page::Info.new

    expect(page.has_textbox?).to be true
  end
end