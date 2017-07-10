require 'sinatra/base'
require 'json'
require 'json/add/exception'
require_relative 'service'


class App < Sinatra::Base
  post '/api/item/add' do
    data = JSON.parse(request.body.read)
    if (data['room'] == false)
      result = Items::Service.store_item(data)
    else
      begin
        result = Items::Service.store_room(data)
      rescue => ArgumentError
        status 503
        body 'Creating rooms inside scenes or other rooms is not allowed'
        result = ArgumentError
      end
    end
    result.to_json
  end

  post '/api/item/retrieve' do
    item = JSON.parse(request.body.read)
    result = Items::Service.retrieve(item['id'])
    result.to_json
  end

  post '/api/room/retrieve' do
    room = JSON.parse(request.body.read)
    result = Items::Service.retrieve(room['id'])
    result.to_json
  end
end
