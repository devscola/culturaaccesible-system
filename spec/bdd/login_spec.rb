require 'spec_helper_bdd'
require_relative 'test_support/login'
require_relative 'test_support/exhibitions'

feature 'Login' do
  scenario 'login succeded goes to home page',:wip do
    current = Page::Login.new

    current.fill('username', 'fer')
    current.fill('password', 'fernando')
    current.submit
    expect(current.content?('EXHIBITIONS')).to be false

    current.fill('username', 'fernando')
    current.fill('password', 'LasNaves2015')
    current.submit
    expect(current.content?('EXHIBITIONS')).to be true
  end
  scenario 'unlogged user cannot access to other url' do
    current = Page::Login.new
    current.fill('username', 'fer')
    current.fill('password', 'fernando')
    current.submit
    visit('/home')
    expect(current.content?('LOG IN')).to be true
  end
end
