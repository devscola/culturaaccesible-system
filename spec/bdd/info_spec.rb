require 'spec_helper_bdd'
require_relative 'test_support/info'
require_relative '../../app'

feature 'Info form' do
  let(:page) do
    Page::Info.new
  end

  scenario 'form hide when submitted' do
    page.fill('name', 'muvim')
    page.fill('description', 'description test 1')
    page.save

    expect(page.has_save_button?).to be false
  end
end
