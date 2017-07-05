require 'sinatra/base'
require 'json'
require_relative 'service'

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

  post '/api/exhibition/retrieve-for-list-fake' do
    exhibition = {
      "name": "exhibition-name",
      "id": "",
      "children": [
        {
          "id": "as76876fsdgg6h78fasdg7h",
          "title": "Soy un item",
          "type": "item"
        },
        {
          "id": "as76hkjhgggg6h78fasa4a",
          "title": "Soy un item",
          "type": "item"
        },
        {
          "id": "as7fasdfasfasdfasffads",
          "title": "Soy un room",
          "type": "room"
        }
      ]
    }
    result = []
    Exhibitions::Service.list.each do |item|
      exhibition['id'] = item[:id]
      exhibition['name'] = item[:name]
      result.push(exhibition)
    end

  post '/api/exhibition/retrieve-for-list' do
    exhibition = JSON.parse(request.body.read)
    result = Exhibitions::Service.retrieve_for_list(exhibition['id'])

    result.to_json
  end

  post '/api/exhibition/list' do
    response.headers['Access-Control-Allow-Origin'] = '*'
    result = Exhibitions::Service.list
    result.to_json
  end

  get '/api/exhibition/flush' do
    Exhibitions::Service.flush
  end
end
