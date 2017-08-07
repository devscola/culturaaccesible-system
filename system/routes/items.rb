require 'sinatra/base'
require 'json'
require 'json/add/exception'
require_relative '../items/service'

class App < Sinatra::Base
  post '/api/item/add' do
    data = JSON.parse(request.body.read)
    if (data['room'] == false)
      result = Items::Service.store_scene(data)
      item_id = result[:id]
      number = data['number']
      Exhibitions::Service.register_order(data['exhibition_id'], item_id, number)
      exhibition = Exhibitions::Service.retrieve(data['exhibition_id'])
    else
      message_exception = 'Store or update item error'
      begin
        result = Items::Service.store_room(data)
        item_id = result[:id]
        number = data['number']
        Exhibitions::Service.register_order(data['exhibition_id'], item_id, number)
      rescue => ArgumentError
        status 503
        body message_exception
        result = ArgumentError
      end
    end
    result.to_json
  end

  post '/api/item/update' do
    data = JSON.parse(request.body.read)
    if (data['room'] == false)
      message_exception = 'Updating room not allows changing it to scene'
      begin
        result = Items::Service.store_scene(data)
      rescue => ArgumentError
        status 503
        body message_exception
        result = ArgumentError
      end
    else
      message_exception = 'Updating scene not allows changing it to room'
      begin
        result = Items::Service.store_room(data)
      rescue => ArgumentError
        status 503
        body message_exception
        result = ArgumentError
      end
    end
    result.to_json
  end

  post '/api/scene/retrieve' do
    scene = JSON.parse(request.body.read)
    exhibition_id = scene['exhibition_id']
    item_id = scene['id']

    result = Items::Service.retrieve(scene['id'])
    ordinal = Exhibitions::Service.retrieve_ordinal(exhibition_id, item_id)
    result['number'] = ordinal

    result.to_json
  end

  post '/api/room/retrieve' do
    room = JSON.parse(request.body.read)
    exhibition_id = room['exhibition_id']
    item_id = room['id']

    result = Items::Service.retrieve(item_id)
    ordinal = Exhibitions::Service.retrieve_ordinal(exhibition_id, item_id)
    result['number'] = ordinal
    result.to_json
  end

end
