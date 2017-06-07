require 'sinatra/base'
require 'json'
require_relative 'service'

class App < Sinatra::Base
  post '/api/museum/add' do
    museum_data = JSON.parse(request.body.read)
    result = Museums::Service.store(museum_data)
    result.to_json
  end

  post '/api/museum/retrieve' do
    museum = JSON.parse(request.body.read)
    result = Museums::Service.retrieve(museum['id'])
    result.to_json
  end
end