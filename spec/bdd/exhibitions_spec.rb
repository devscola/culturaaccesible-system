require 'spec_helper_bdd'
require_relative 'test_support/exhibitions'
require_relative '../../app'

feature 'Form' do
  scenario 'allows submit when required fields filled' do
    page = Page::Exhibitions.new
    page.show_exhibition_form

    page.fill('name', 'some name')
    page.fill('location', 'some location')

    expect(page.form_submit_deactivated?).to be false
  end
end

feature 'Add exhibition button' do
	scenario 'shows exhibition form' do
    page = Page::Exhibitions.new

    page.show_exhibition_form

    expect(page.exhibition_form_visible?). to be true

  end
end
