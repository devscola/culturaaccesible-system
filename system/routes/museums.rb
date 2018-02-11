require 'sinatra/base'
require 'json'
require_relative '../museums/service'
require_relative '../helpers/logged'
require_relative '../../environment_configuration'

class App < Sinatra::Base
  enable :sessions
  include Logged

  post '/api/museum/add' do
    museum_data = JSON.parse(request.body.read)
    result = Museums::Service.store(museum_data)
    translations = Museums::Service.store_translations(museum_data['translations'], result[:id]) if museum_data['translations']
    result[:translations] = translations
    result.to_json
  end

  post '/api/museum/retrieve' do
    response.headers['Access-Control-Allow-Origin'] = '*'
    body = JSON.parse(request.body.read)
    result = Museums::Service.retrieve(body['id'])
    museum_translations =  Museums::Service.retrieve_translations(result[:id])
    result['translations'] = museum_translations if museum_translations.size > 0
    result.to_json
  end

  post '/api/museum/retrieve-translated' do
    response.headers['Access-Control-Allow-Origin'] = '*'
    body = JSON.parse(request.body.read)
    result = Museums::Service.retrieve_translated(body['id'], body['iso_code'])
    result.to_json
  end

  post '/api/museum/list' do
    response.headers['Access-Control-Allow-Origin'] = '*'
    body = JSON.parse(request.body.read)
    result = Museums::Service.list(body['iso_code'])
    result.to_json
  end

  get '/api/museum/flush' do
    return {valid: false}.to_json if !login? || retrieve_mode == 'production'
    Museums::Service.flush
    {}
  end
end
