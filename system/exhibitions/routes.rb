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

  post '/api/exhibition/list' do
    result = Exhibitions::Service.list
    result.to_json
  end
end
