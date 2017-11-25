require 'sinatra/base'
require 'json'
require_relative '../museums/service'
require_relative '../exhibitions/service'
require_relative '../actions/exhibitions'
require_relative '../helpers/faker'

class App < Sinatra::Base

  include Admin

  get '/api/fixtures/exhibition' do
    exhibition_data = { 'name' => 'some name', 'location' => 'some location' }
    Exhibitions::Service.store(exhibition_data)
  end

  get '/api/fill/admin' do
    Exhibitions::Service.flush
    Museums::Service.flush
    museum = store_museum
    exhibition = store_exhibition(museum[:id])
    store_sculpture_room(exhibition[:id])
    store_painting_room(exhibition[:id])
    {}.to_json
  end
end
