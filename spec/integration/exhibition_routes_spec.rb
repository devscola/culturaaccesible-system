require 'rack/test'
require 'json'
require_relative '../../system/exhibitions/routes'
require_relative '../../system/exhibitions/repository'

describe 'Exhibition controller' do
  include Rack::Test::Methods

  def app
    App.new
  end

  before(:each) do
    Exhibitions::Repository.flush
  end

  it 'stores exhibitions with id' do
    add_exhibition
    first_exhibition_id = parse_response['id']
    
    add_exhibition
    second_exhibition_id = parse_response['id']

    expect(first_exhibition_id == second_exhibition_id).to be false
  end 

  it 'retrieves required exhibition' do
    add_exhibition
    exhibition_id = parse_response['id']
    payload = { id: exhibition_id }.to_json
    post '/api/exhibition/retrieve', payload

    result = parse_response['location']
    expect(result).to eq('some location')
  end

  it 'retrieves all exhibitions' do
    add_exhibition

    post '/api/exhibition/list'

    result = parse_response
    expect(result.any?).to be true
  end

  it 'updates existing exhibition' do
    add_exhibition
    exhibition_id = parse_response['id']

    exhibition_updated = { 
      id: exhibition_id, 
      name: 'some other name', 
      location: 'some location'
    }.to_json
    post '/api/exhibition/add', exhibition_updated
    payload = { id: exhibition_id }.to_json
    post '/api/exhibition/retrieve', payload

    result = parse_response['name']
    expect(result).to eq 'some other name'
  end

  def add_exhibition
    exhibition = { name: 'some name', location: 'some location' }.to_json
    post '/api/exhibition/add', exhibition
  end

  def parse_response
    JSON.parse(last_response.body)
  end
end
