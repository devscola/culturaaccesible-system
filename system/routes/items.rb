require 'sinatra/base'
require 'json'
require 'json/add/exception'
require_relative '../items/service'

class App < Sinatra::Base
  post '/api/item/add' do
    data = JSON.parse(request.body.read)
    message_exception = 'Store or update item number error, number allready exist'
    begin
      exhibition = Exhibitions::Service.retrieve(data['exhibition_id'])
      numbers = exhibition[:order][:index].keys || []
      raise message_exception if numbers.include? data['number']
    rescue RuntimeError => error
      status 503
      body message_exception
      return error.to_json
    end
    if (data['room'] == false)
      result = Items::Service.store_scene(data)
      item_id = result[:id]
      number = data['number']
      Exhibitions::Service.register_order(data['exhibition_id'], item_id, number)
      translations = Items::Service.store_translations(data['translations'], item_id) if data['translations']
      result['translations'] = translations
      Exhibitions::Service.retrieve(data['exhibition_id'])
    else
      message_exception = 'Store or update item error'
      result = manage_exception(message_exception) do
        result = Items::Service.store_room(data)
        item_id = result[:id]
        number = data['number']
        Exhibitions::Service.register_order(data['exhibition_id'], item_id, number)
        translations = Items::Service.store_translations(data['translations'], item_id) if data['translations']
        result['translations'] = translations
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
        item_id = result[:id]
        number = data['number']
        last_number = data['last_number']
        Exhibitions::Service.update_order(data['exhibition_id'], item_id, number, last_number)
        translations = Items::Service.update_translations(data['translations'], item_id) if data['translations']
        result['translations'] = translations
        result
      end
    else
      message_exception = 'Updating scene not allows changing it to room'
      result = manage_exception(message_exception) do
        result = Items::Service.store_room(data)
        item_id = result[:id]
        number = data['number']
        last_number = data['last_number']
        Exhibitions::Service.update_order(data['exhibition_id'], item_id, number, last_number)
        translations = Items::Service.update_translations(data['translations'], item_id) if data['translations']
        result['translations'] = translations
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
    item_id = result[:id]
    translations = Items::Service.retrieve_translations(item_id)
    result['translations'] = translations
    message_exception = 'Item not found'
    result = manage_exception(message_exception) do
      ordinal = Exhibitions::Service.retrieve_ordinal(exhibition_id, item_id)
      result['number'] = ordinal
      result
    end
    result.to_json
  end

  get '/api/item/flush' do
    Items::Service.flush
    {}
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
