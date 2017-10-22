require 'sinatra/base'
require 'json'
require_relative '../authorization/service'

class App < Sinatra::Base
  post '/api/login' do
    payload = JSON.parse(request.body.read)
    username = payload['username']
    password = payload['password']

    response = Authorization::Service.verify(username, password)

    if response
      { valid: true, token: response }.to_json
    else
      { valid: false }.to_json
    end
  end
end
