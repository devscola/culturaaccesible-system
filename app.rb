require 'sinatra/base'
require_relative 'system/exhibitions/routes'

class App < Sinatra::Base
  set :public_folder, 'public/'
  enable :static

  get '/home' do
    File.read(File.join('public', 'home.html'))
  end
end
