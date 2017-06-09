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

  get '/museum' do
    File.read(File.join('public', 'museum.html'))
  end

  get '/item' do
    File.read(File.join('public', 'item.html'))
  end

end
