require 'sinatra/base'
require_relative 'system/exhibitions/routes'
require_relative 'system/museums/routes'
require_relative 'system/items/routes'


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

  get '/items/:id' do
    File.read(File.join('public', 'item.html'))
  end

  get '/exhibition/:id' do
    File.read(File.join('public', 'exhibition-info.html'))
  end

end
