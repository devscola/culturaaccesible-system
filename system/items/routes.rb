require 'sinatra/base'
require 'json'
require_relative 'service'

class App < Sinatra::Base
  post '/api/item/add' do
    data = JSON.parse(request.body.read)
    if (data['room'] == false)
      result = Items::Service.store_item(data)
    else
      result = Items::Service.store_room(data)
    end
    result.to_json
  end

  post '/api/item/retrieve' do
    item = JSON.parse(request.body.read)
    result = Items::Service.retrieve(item['id'])
    result.to_json
  end
end
