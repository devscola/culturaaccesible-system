require 'rack/test'
require 'json'
require_relative '../../system/museums/routes'

describe 'Museum controller' do
  include Rack::Test::Methods

  def app
    App.new
  end

  before(:each) do
    Museums::Service.flush
  end

  it 'retrieve required museum' do
    museum = { id: 'museum_id', name: 'some name' }.to_json
    post '/api/museum/add', museum

    museum_id = { id: 'museum_id' }.to_json
    post '/api/museum/retrieve', museum_id
    result = parse_response['name']

    expect(result).to eq('some name')
  end

  it 'retrieves all museums', :museum do
    post '/api/museum/list'

    result = parse_response
    
    expect(result).to be_an Array
  end

  def parse_response
    JSON.parse(last_response.body)
  end
end
