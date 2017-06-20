require 'rack/test'
require 'json'
require_relative '../../system/museums/routes'
require_relative '../../system/museums/repository'

describe 'Museum controller' do
  include Rack::Test::Methods

  def app
    App.new
  end

  before(:each) do
    Museums::Repository.flush
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

  it 'stores museum with id' do
    add_museum
    first_museum_id = parse_response['id']

    add_museum
    second_museum_id = parse_response['id']

    expect(first_museum_id == second_museum_id).to be false
  end

end

  def add_museum
    museum = {
        info: {name: 'some name', description: 'some description'},
        location: {street: 'some street'}
      }.to_json
    post '/api/museum/add', museum
  end

  def parse_response
    JSON.parse(last_response.body)
  end
