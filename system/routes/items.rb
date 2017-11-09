require 'sinatra/base'
require 'json'
require 'json/add/exception'
require_relative '../actions/items'
require_relative '../items/service'

class App < Sinatra::Base
  post '/api/item/add' do
    data = JSON.parse(request.body.read)
    result = Actions::Item.add(data)
    result.to_json
  end

  post '/api/item/update' do
    data = JSON.parse(request.body.read)
    result = Actions::Item.update(data)
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
