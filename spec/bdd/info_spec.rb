require 'spec_helper_bdd'
require_relative 'test_support/info'
require_relative '../../app'

feature 'Info form' do
  scenario 'form hide when submitted', :wip do
    info = Page::Info.new
    info.fill('name', 'some name')
    info.fill('description', 'some description')
    info.save

    result = info.has_form?

    expect(result).to be false
  end
end
