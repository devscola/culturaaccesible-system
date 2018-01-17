require 'rack/test'
require 'json'
require_relative '../../system/routes/museums'
require_relative '../../system/museums/repository'

describe 'Museum controller' do
  include Rack::Test::Methods

  SPANISH = 'es'
  ENGLISH = 'en'
  CATALA = 'cat'
  ISO_CODES = [SPANISH, ENGLISH]

  def app
    App.new
  end

  before(:each) do
    Museums::Repository.flush
  end

  context 'creating' do
    it 'stores museum' do
      add_museum
      first_museum_id = parse_response['id']
      add_museum
      second_museum_id = parse_response['id']

      expect(first_museum_id == second_museum_id).to be false
    end
    it 'stores museum with translations' do
      add_museum
      museum = parse_response

      expect(museum['translations'][0]['iso_code']).to eq SPANISH
      expect(museum['translations'][1]['iso_code']).to eq ENGLISH
      expect(museum['translations'][0]['description']).to eq 'descripción'
      expect(museum['translations'][1]['description']).to eq 'description'
    end
  end

  context 'retrieving' do
    it 'all museums' do
      add_museum

      post '/api/museum/list'
      museums = parse_response

      expect(museums.any?).to be true
    end

    it 'museum' do
      add_museum
      museum_id = parse_response['id']
      payload = { id: museum_id }.to_json

      post '/api/museum/retrieve', payload
      museum = parse_response

      expect(museum['info']['name']).to eq 'some name'
      expect(museum['id']).to eq museum_id
    end

    it 'museum translated' do
      add_museum
      museum_id = parse_response['id']
      payload = { id: museum_id, iso_code: 'es' }.to_json

      post '/api/museum/retrieve-translated', payload
      museum = parse_response

      expect(museum['info']['description']).to eq 'descripción'
      expect(museum['info']['name']).to eq 'some name'
      expect(museum['id']).to eq museum_id
    end

    it 'museum with translations' do
      add_museum
      museum_id = parse_response['id']
      payload = { id: museum_id }.to_json

      post '/api/museum/retrieve', payload
      museum = parse_response

      expect(museum['translations'][0]['iso_code']).to eq SPANISH
      expect(museum['translations'][1]['iso_code']).to eq ENGLISH
      expect(museum['translations'][0]['description']).to eq 'descripción'
      expect(museum['translations'][1]['description']).to eq 'description'
    end
  end

  context 'updating' do
    it 'updates museum returns updated data' do
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
end

def add_museum
  museum = {
      info: {name: 'some name', description: 'some description'},
      location: {street: 'some street'},
      translations: museum_languages,
      iso_codes: ISO_CODES,
    }.to_json
  post '/api/museum/add', museum
end

def museum_languages
  [
    {'description' => 'descripción', 'iso_code' => SPANISH},
    {'description' => 'description', 'iso_code' => ENGLISH},
  ]
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
