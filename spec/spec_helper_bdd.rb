require 'sinatra'
require 'capybara'
require 'capybara/rspec'

SINATRA_PORT = 4567

Sinatra::Application.environment = :test

Capybara.app = Sinatra::Application
Capybara.app_host = "http://localhost:#{SINATRA_PORT}"

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.default_driver = :chrome
