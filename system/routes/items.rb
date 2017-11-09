require 'sinatra/base'
require 'json'
require 'json/add/exception'
require_relative '../actions/items'
require_relative '../items/service'

class App < Sinatra::Base
  post '/api/item/add' do
    data = JSON.parse( request.body.read )
    result = Actions::Item.add( data )
    result.to_json
  end

  post '/api/item/update' do
    data = JSON.parse( request.body.read )
    result = Actions::Item.update( data )
    result.to_json
  end

  post '/api/item/delete' do
    data = JSON.parse( request.body.read )
    Actions::Exhibition.delete_item( data['id'], data['exhibition_id'] )
    { message: 'item has been deleted' }.to_json
  end

  post '/api/item/retrieve' do
    data = JSON.parse(request.body.read)
    result = Actions::Item.retrieve( data['exhibition_id'], data['id'] )
    result.to_json
  end

  get '/api/item/flush' do
    Items::Service.flush
    {}
  end

end
