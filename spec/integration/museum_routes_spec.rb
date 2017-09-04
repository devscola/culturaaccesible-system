require 'rack/test'
require 'json'
require_relative '../../system/routes/museums'
require_relative '../../system/museums/repository'

describe 'Museum controller' do
  include Rack::Test::Methods

  def app
    App.new
  end

  before(:each) do
    Museums::Repository.flush
  end

  it 'retrieves all museums' do
    add_museum
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

  it 'retrieve museum by id' do
    add_museum
    museum_id = parse_response['id']
    payload = { id: museum_id }.to_json

    post '/api/museum/retrieve', payload

    museum_name = parse_response['info']['name']
    expect(museum_name).to eq 'some name'
  end

  it 'updates museum returns updated phone and price data' do
    old_name = 'some name'
    new_museum_name = 'some updated name'

    add_museum
    museum_id = parse_response['id']

    update_museum(museum_id)
    updated_museum = parse_response

    expect(museum_id).to eq updated_museum['id']
    expect(new_museum_name).to eq updated_museum['info']['name']
    expect(updated_museum['contact']['phone']).to eq ['123456789', '987654321']
    expect(updated_museum['price']['general']).to eq ['25', '30']
  end
end

  def add_museum
    museum = {
        info: {name: 'some name', description: 'some description'},
        location: {street: 'some street'}
      }.to_json
    post '/api/museum/add', museum
  end

  def update_museum(id)
    museum = {
        id: id,
        info: {name: 'some updated name', description: 'some description'},
        location: {street: 'some street'},
        contact: {phone: ['123456789', '987654321']},
        price: {general: ['25', '30']}
      }.to_json
    post 'api/museum/add', museum
  end

  def parse_response
    JSON.parse(last_response.body)
  end
