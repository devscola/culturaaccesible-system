require 'spec_helper_bdd'
require_relative 'test_support/schedule'
require_relative '../../app'

feature 'Schedule form', :wip do
  scenario 'is instanciated' do
    current = Page::Schedule.new
    expect(current.is_instanciated?).to be true
  end
end
