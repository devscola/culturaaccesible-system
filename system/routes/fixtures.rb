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
    museum = store_museum
    exhibition = store_exhibition(museum[:id])
    store_room( exhibition[:id] )
    store_item( exhibition[:id] )
    {}.to_json
  end
end
