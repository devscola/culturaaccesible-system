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
    add_exhibition

    result = parse_response['name']
    expect(result).to eq('some name')
  end

  it 'retrieves required exhibition' do
    add_exhibition
    exhibition_data = { name: 'some name' }.to_json
    post '/api/exhibition/retrieve', exhibition_data

    result = parse_response['location']
    expect(result).to eq('some location')
  end

  it 'retrieves all exhibitions' do
    add_exhibition

    post '/api/exhibition/list'

    result = parse_response
    expect(result.any?).to be true
  end

  def add_exhibition
    exhibition = { name: 'some name', location: 'some location' }.to_json
    post '/api/exhibition/add', exhibition
  end

  def parse_response
    JSON.parse(last_response.body)
  end
end
