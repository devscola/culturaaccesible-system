require 'sinatra/base'
require_relative 'environment_configuration'
require_relative 'system/authorization/service'
require_relative 'system/helpers/logged'

class App < Sinatra::Base
  enable :static, :sessions
  include Logged
  set :public_folder, 'public/'

  GO_TO_LOGIN =  File.read(File.join('public', 'login.html'))

  get '/' do
    GO_TO_LOGIN
  end

  get '/home' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'exhibitions.html'))
  end

  get '/exhibition/:id/info' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'exhibition-info.html'))
  end

  get '/exhibition/:id/edit' do
    return GO_TO_LOGIN if !login?
      File.read(File.join('public', 'exhibition-edit.html'))
  end

  get '/museum' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'museum.html'))
  end

  get '/museum/:id' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'museum-info.html'))
  end

  get '/museum/:id/edit' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'museum.html'))
  end


  get '/exhibition/:id/exhibition/:exhibition_id/edit' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'item.html'))
  end

  get '/exhibition/:id/room/:room_id' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'room-info.html'))
  end

  get '/room-info' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'room-info.html'))
  end

  get '/scene-info' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'scene-info.html'))
  end

  get '/exhibition/:id/scene/:scene_id' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'scene-info.html'))
  end

  get '/exhibition/:id/exhibition/:exhibition_id/item' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'item.html'))
  end

  get '/exhibition/:id/scene/:scene_id/item' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'item.html'))
  end

  get '/exhibition/:id/room/:room_id/item' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'item.html'))
  end

  get '/exhibition/:id/room/:room_id/edit' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'item.html'))
  end

  get '/exhibition/:id/scene/:scene_id/edit' do
    return GO_TO_LOGIN if !login?
    File.read(File.join('public', 'item.html'))
  end
end
require_relative 'system/routes/exhibitions'
require_relative 'system/routes/museums'
require_relative 'system/routes/items'
require_relative 'system/routes/login'
require_relative 'system/routes/fixtures'
