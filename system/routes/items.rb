require 'sinatra/base'
require 'json'
require 'json/add/exception'
require_relative '../items/service'

class App < Sinatra::Base
  post '/api/item/add' do
    data = JSON.parse(request.body.read)
    if (data['room'] == false)
      result = Items::Service.store_scene(data)
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

  post '/api/item/update' do
    data = JSON.parse(request.body.read)
    if (data['room'] == false)
      result = Items::Service.store_scene(data)
    else
      result = Items::Service.store_room(data)
    end
    result.to_json
  end

  post '/api/scene/retrieve' do
    scene = JSON.parse(request.body.read)
    result = Items::Service.retrieve(scene['id'])
    result.to_json
  end

  post '/api/room/retrieve' do
    room = JSON.parse(request.body.read)
    result = Items::Service.retrieve(room['id'])
    result.to_json
  end
end
