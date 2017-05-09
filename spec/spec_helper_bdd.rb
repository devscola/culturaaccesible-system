require 'sinatra'
require 'capybara'
require 'capybara/rspec'
require 'selenium-webdriver'

def use_chrome
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
  Capybara.default_driver = :chrome
  Capybara.app_host = "http://localhost:4567"
end

use_chrome
