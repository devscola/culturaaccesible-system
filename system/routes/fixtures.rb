require 'sinatra/base'
require 'json'
require_relative '../exhibitions/service'
require_relative '../actions/exhibitions'

class App < Sinatra::Base
  get '/api/fixtures/exhibition' do
    exhibition_data = { 'name' => 'some name', 'location' => 'some location' }
    Exhibitions::Service.store(exhibition_data)
  end
end
