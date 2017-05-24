require 'spec_helper_bdd'
require_relative 'test_support/info'
require_relative '../../app'

feature 'Info form' do
  scenario 'form hide when submitted' do
    current = Page::Info.new
    current.fill('name', 'some name')
    current.fill('description', 'some description')
    current.save

    expect(current.has_form?).to be false
  end
end
