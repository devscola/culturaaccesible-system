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
    else
      message_exception = 'Store or update item error'
      result = manage_exception(message_exception) do
        result = Items::Service.store_room(data)
        item_id = result[:id]
        number = data['number']
        Exhibitions::Service.register_order(data['exhibition_id'], item_id, number)
        result
      end
    end
    result.to_json
  end


  post '/api/item/update' do
    data = JSON.parse(request.body.read)
    if (data['room'] == false)
      message_exception = 'Updating room not allows changing it to scene'
      result = manage_exception(message_exception) do
        result = Items::Service.store_scene(data)
        result
      end
    else
      message_exception = 'Updating scene not allows changing it to room'
      result = manage_exception(message_exception) do
        result = Items::Service.store_room(data)
        result
      end
    end
    result.to_json
  end

  post '/api/item/delete' do
    data = JSON.parse(request.body.read)
    id = data['id']
    exhibition_id = data['exhibition_id']

    Actions::Exhibition.delete_item(id, exhibition_id)
    { message: 'item has been deleted' }.to_json
  end

  post '/api/item/retrieve' do
    item = JSON.parse(request.body.read)
    exhibition_id = item['exhibition_id']
    item_id = item['id']

    result = Items::Service.retrieve(item_id)
    message_exception = 'Item not found'
    result = manage_exception(message_exception) do
      ordinal = Exhibitions::Service.retrieve_ordinal(exhibition_id, item_id)
      result['number'] = ordinal
      result
    end
    result.to_json
  end

  def manage_exception(message)
    begin
      yield
    rescue ArgumentError => error
      status 503
      body message
      error
    end
  end
end
