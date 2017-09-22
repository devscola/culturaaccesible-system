require 'sinatra/base'
require_relative 'system/routes/exhibitions'
require_relative 'system/routes/museums'
require_relative 'system/routes/items'
require_relative 'system/routes/fixtures'

class App < Sinatra::Base
  set :public_folder, 'public/'
  enable :static

  get '/' do
    File.read(File.join('public', 'exhibitions.html'))
  end

  get '/home' do
    File.read(File.join('public', 'exhibitions.html'))
  end

  get '/exhibition/:id/info' do
    File.read(File.join('public', 'exhibition-info.html'))
  end

  get '/exhibition/:id/edit' do
      File.read(File.join('public', 'exhibition-edit.html'))
  end

  get '/museum' do
    File.read(File.join('public', 'museum.html'))
  end

  get '/museum/:id' do
    File.read(File.join('public', 'museum-info.html'))
  end

  get '/museum/:id/edit' do
      File.read(File.join('public', 'museum.html'))
  end


  get '/exhibition/:id/exhibition/:exhibition_id/edit' do
    File.read(File.join('public', 'item.html'))
  end

  get '/exhibition/:id/room/:room_id' do
    File.read(File.join('public', 'room-info.html'))
  end

  get '/room-info' do
    File.read(File.join('public', 'room-info.html'))
  end

  get '/scene-info' do
    File.read(File.join('public', 'scene-info.html'))
  end

  get '/exhibition/:id/scene/:scene_id' do
    File.read(File.join('public', 'scene-info.html'))
  end

  get '/exhibition/:id/exhibition/:exhibition_id/item' do
    File.read(File.join('public', 'item.html'))
  end

  get '/exhibition/:id/scene/:scene_id/item' do
    File.read(File.join('public', 'item.html'))
  end

  get '/exhibition/:id/room/:room_id/item' do
    File.read(File.join('public', 'item.html'))
  end

  get '/exhibition/:id/room/:room_id/edit' do
      File.read(File.join('public', 'item.html'))
  end

  get '/exhibition/:id/scene/:scene_id/edit' do
      File.read(File.join('public', 'item.html'))
  end
end
