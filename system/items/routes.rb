require 'sinatra/base'
require 'json'
require_relative 'service'

class App < Sinatra::Base
  post '/api/item/add' do
    item_data = JSON.parse(request.body.read)
    result = Items::Service.store(item_data)
    result.to_json
  end

  post '/api/item/retrieve' do
    item = JSON.parse(request.body.read)
    result = Items::Service.retrieve(item['id'])
    result.to_json
  end
end
