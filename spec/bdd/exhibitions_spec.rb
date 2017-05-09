require 'spec_helper_bdd'
require_relative 'test_support/exhibitions'
require_relative '../../app'

feature 'Form' do
  scenario 'allows submit when required fields filled' do
    page = Page::Exhibitions.new

    page.fill('name', 'some name')
    page.fill('location', 'some location')

    expect(page.form_submit_deactivated?).to be false
  end
end
