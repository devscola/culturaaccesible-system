require 'sinatra/base'
require 'json'
require_relative '../exhibitions/service'
require_relative '../actions/exhibitions'
require_relative '../items/repository'
require_relative '../museums/repository'
require_relative '../items/scene'
require_relative '../items/room'

class App < Sinatra::Base
  post '/api/exhibition/add' do
    exhibition_data = JSON.parse(request.body.read)
    result = Exhibitions::Service.store(exhibition_data)
    exhibition_id = result[:id]
    translations = Exhibitions::Service.store_translations(exhibition_data['translations'], exhibition_id) if exhibition_data['translations']
    result[:translations] = translations
    result = Actions::Exhibition.add_museum_info(result) if result[:museum_id].size > 0
    result.to_json
  end

  post '/api/exhibition/delete' do
    exhibition = JSON.parse(request.body.read)
    Exhibitions::Service.delete(exhibition['id'])
    { message: 'Exhibition has been deleted' }.to_json
  end

  post '/api/exhibition/retrieve' do
    exhibition = JSON.parse(request.body.read)
    result = Exhibitions::Service.retrieve(exhibition['id'])
    result = Actions::Exhibition.add_museum_info(result) if result[:museum_id].size > 0
    result['numbers'] = result[:order][:index].keys()
    result.to_json
  end

  post '/api/exhibition/retrieve-for-list' do
    body = JSON.parse(request.body.read)
    exhibition = Exhibitions::Service.retrieve(body['id'])
    result = Actions::Exhibition.retrieve_for_list(exhibition)
    result.to_json
  end

  post '/api/exhibition/items' do
    response.headers['Access-Control-Allow-Origin'] = '*'
    body = JSON.parse(request.body.read)
    exhibition_id = body['exhibition_id']

    order = Exhibitions::Repository.retrieve(exhibition_id).order
    result = Items::Service.retrieve_by_parent(exhibition_id, order)

    result.to_json
  end

  post '/api/exhibition/list' do
    response.headers['Access-Control-Allow-Origin'] = '*'
    result = Exhibitions::Service.list
    result.to_json
  end

  post '/api/exhibition/retrieve-next-ordinal' do
    data = JSON.parse(request.body.read)
    number = '0-0-0'
    if(data['parent_class'] != 'exhibition')
      item = Items::Repository.retrieve(data['parent_id'])
      exhibition = Exhibitions::Repository.retrieve(data['exhibition_id'])
      number = exhibition.order.retrieve_ordinal(item.id)
    end
    result = Exhibitions::Service.retrieve_next_ordinal(data['exhibition_id'], number)

    result.to_json
  end

  post '/api/exhibition/download' do
    body = JSON.parse(request.body.read)
    exhibition_id = body['id']
    iso_code = body['iso_code']
    exhibition = Exhibitions::Service.retrieve_translated(exhibition_id, iso_code)
    result = Actions::Exhibition.retrieve_all_items(exhibition, iso_code)
    exhibition['items'] = result
    exhibition.to_json
  end

  get '/api/exhibition/flush' do
    Exhibitions::Service.flush
    {}
  end
end
