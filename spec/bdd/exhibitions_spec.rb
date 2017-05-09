require 'spec_helper_bdd'
require_relative 'test_support/exhibitions'

feature 'List exhibitions' do 

  scenario 'has items' do
    page = Page::Exhibitions.new
    expect(page.exhibition_list?).to be true
  end

end
