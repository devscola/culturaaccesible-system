require 'sinatra/base'
require 'json'
require_relative '../exhibitions/service'
require_relative '../actions/exhibitions'
require_relative '../items/repository'
require_relative '../items/scene'
require_relative '../items/room'

class App < Sinatra::Base
  post '/api/exhibition/add' do
    exhibition_data = JSON.parse(request.body.read)
    result = Exhibitions::Service.store(exhibition_data)
    result.to_json
  end

  post '/api/exhibition/retrieve' do
    exhibition = JSON.parse(request.body.read)
    result = Exhibitions::Service.retrieve(exhibition['id'])
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

    exhibition = Exhibitions::Repository.retrieve(body['exhibition_id'])

    result = Items::Service.retrieve_by_parent(exhibition.id)

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

  get '/api/exhibition/flush' do
    Exhibitions::Service.flush
    {}
  end
end
