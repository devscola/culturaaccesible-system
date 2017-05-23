require 'spec_helper_bdd'
require_relative 'test_support/exhibitions'
require_relative '../../app'

feature 'List exhibitions' do
  scenario 'has items' do
    page = Page::Exhibitions.new
    page.add_exhibition
    expect(page.exhibition_list?).to be true
  end
end

feature 'Add exhibition button' do
  scenario 'shows exhibition form' do
    page = Page::Exhibitions.new

    page.show_exhibition_form

    expect(page.exhibition_form_visible?). to be true
  end
end

feature 'Form' do
  scenario 'disallows submit without required conditions fulfilled' do
    exhibitions = Page::Exhibitions.new
    exhibitions.show_exhibition_form

    result = exhibitions.form_submit_deactivated?

    expect(result).to be true
  end

  scenario 'allows submit when required fields filled', :wip do
    exhibitions = Page::Exhibitions.new
    exhibitions.show_exhibition_form

    exhibitions.fill('name', 'some name')
    exhibitions.fill('location', 'some location')

    expect(exhibitions.form_submit_deactivated?).to be false
  end
end


feature 'Exhibition panel' do
  scenario 'displays when form is submited' do
    page = Page::Exhibitions.new
    page.show_exhibition_form

    page.fill('name', 'some name')
    page.fill('location', 'some location')
    page.save_exhibition

    expect(page.exhibition_panel_visible?).to be true
  end
end
