require 'sinatra/base'
require 'json'
require_relative '../authorization/service'

class App < Sinatra::Base
  enable :sessions
  post '/api/login' do
    payload = JSON.parse(request.body.read)
    username = payload['username']
    password = payload['password']
    session[:registered] = false

    response = Authorization::Service.verify(username, password)
    session[:registered] = response
    { valid: session[:registered] }.to_json
  end
end
