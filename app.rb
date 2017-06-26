require 'sinatra/base'
require_relative 'system/exhibitions/routes'
require_relative 'system/museums/routes'

class App < Sinatra::Base
  set :public_folder, 'public/'
  enable :static

  get '/' do
    File.read(File.join('public', 'exhibitions.html'))
  end

  get '/home' do
    File.read(File.join('public', 'exhibitions.html'))
  end

  get '/museum' do
    File.read(File.join('public', 'museum.html'))
  end

  get '/item/:id' do
    File.read(File.join('public', 'item.html'))
  end
end
