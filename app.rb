require 'sinatra/base'
require_relative 'system/exhibitions/routes'

class App < Sinatra::Base
  set :public_folder, 'public/'
  enable :static

  get '/' do
    File.read(File.join('public', 'home.html'))
  end

  get '/home' do
    File.read(File.join('public', 'home.html'))
  end

  get '/contact' do
    File.read(File.join('public', 'contact.html'))
  end

  get '/info' do
    File.read(File.join('public', 'info.html'))
  end

  get '/price' do
    File.read(File.join('public', 'price.html'))
  end

  get '/schedule' do
    File.read(File.join('public', 'schedule.html'))
  end
end
