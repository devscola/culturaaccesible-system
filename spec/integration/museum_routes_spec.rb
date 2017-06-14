require 'rack/test'
require 'json'
require_relative '../../system/museums/routes'
require_relative '../../system/museums/test_repository'

describe 'Museum controller', :wip do
  include Rack::Test::Methods

  def app
    App.new
  end

  before(:each) do
    Museums::TestRepository.flush
  end

  it 'retrieve required museum' do
    museum = { info: { name: 'some name', description: 'some description' } }.to_json
    post '/api/museum/add', museum

    payload = { info: { name: 'some name' } }.to_json
    post '/api/museum/retrieve', payload
    result = parse_response['info']['name']

    expect(result).to eq('some name')
  end

  it 'retrieves all museums', :museum do
    museum = { info: { name: 'some name', description: 'some description' } }.to_json
    post '/api/museum/add', museum

    post '/api/museum/list'

    result = parse_response
    expect(result.any?).to be true
  end

  def parse_response
    JSON.parse(last_response.body)
  end
end
