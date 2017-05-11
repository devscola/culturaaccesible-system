require 'rack/test'
require 'json'
require_relative '../../system/exhibitions/routes'

describe 'Exhibition controller' do
  include Rack::Test::Methods

  def app
    App.new
  end

  before(:each) do
    Exhibitions::Service.flush
  end

  it 'stores exhibitions' do
    exhibition = { id: 'exhibition_id', name: 'some name' }.to_json

    post '/api/exhibition/add', exhibition

    expect(parse_response['name']).to eq('some name')
  end

  it 'retrieves required exhibition' do
    exhibition = { id: 'exhibition_id', name: 'some name' }.to_json
    post '/api/exhibition/add', exhibition

    exhibition_id = { id: 'exhibition_id' }.to_json
    post '/api/exhibition/retrieve', exhibition_id

    expect(parse_response['name']).to eq('some name')
  end

  it 'retrieves all exhibitions' do
    post '/api/exhibition/list'
    expect(parse_response).to be_an Array
  end

  def parse_response
    JSON.parse(last_response.body)
  end
end
