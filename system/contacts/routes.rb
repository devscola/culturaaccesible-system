require 'sinatra/base'
require 'json'
require_relative 'service'

class App < Sinatra::Base
  post '/api/contact/add' do
    contact_detail = JSON.parse(request.body.read)
    result = Contacts::Service.store(contact_detail)
    result.to_json
  end
end

