require 'rack/test'
require 'json'
require_relative '../../system/contacts/routes'

describe 'Contacts controller' do
  include Rack::Test::Methods

  def app
    App.new
  end

  before(:each) do
    Contacts::Service.flush
  end

  it 'stores contacts' do
    contact = {
      phone: ['some phone number', 'some other phone number'],
      email: [],
      web: []
    }.to_json

    post '/api/contact/add', contact

    expect(parse_response['phone']).to eq(['some phone number', 'some other phone number'])
  end

  def parse_response
    JSON.parse(last_response.body)
  end
end
