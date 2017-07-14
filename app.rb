require 'sinatra/base'
require_relative 'system/routes/exhibitions'
require_relative 'system/routes/museums'
require_relative 'system/routes/items'

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

  get '/exhibition/:id' do
    File.read(File.join('public', 'exhibition-info.html'))
  end

  get '/room/:id' do
    File.read(File.join('public', 'room-info.html'))
  end

  get '/scene/:id' do
    File.read(File.join('public', 'scene-info.html'))
  end

  get '/exhibition/:id/item' do
    File.read(File.join('public', 'item.html'))
  end

  get '/scene/:id/item' do
    File.read(File.join('public', 'item.html'))
  end

  get '/room/:id/item' do
    File.read(File.join('public', 'item.html'))
  end

  get '/room/:id/edit' do
      File.read(File.join('public', 'item.html'))
  end

  get '/scene/:id/edit' do
      File.read(File.join('public', 'item.html'))
  end

  get '/scene-in-room/:id/edit' do
      File.read(File.join('public', 'item.html'))
  end

  get '/subscene/:id/edit' do
      File.read(File.join('public', 'item.html'))
  end
end
