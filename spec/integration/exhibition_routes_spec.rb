require 'rack/test'
require 'json'
require_relative '../../system/routes/exhibitions'
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

    retrieved_exhibition_id = parse_response['id']
    expect(retrieved_exhibition_id).to eq(exhibition_id)
  end

  it 'retrieves all exhibitions' do
    add_exhibition

    post '/api/exhibition/list'

    result = parse_response
    expect(result.any?).to be true
  end

  it 'retrieves all items in exhibitions' do
    add_exhibition
    exhibition_id = parse_response['id']
    payload = { exhibition_id: exhibition_id }.to_json

    add_item(exhibition_id)

    post '/api/exhibition/items', payload

    result = parse_response

    expect(result.any?).to be true
  end

  it 'retrieves an exhibition for sidebar', :wip do
    add_exhibition
    exhibition_id = parse_response['id']
    payload = { id: exhibition_id }.to_json

    add_item(exhibition_id)

    post '/api/exhibition/retrieve-for-list', payload

    result = parse_response

    expect(result['id']).to eq exhibition_id
    expect(result['children'].any?).to be true
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

  def add_item(exhibition_id)
    scene = { id: '', name: 'name', room: false, parent_id: exhibition_id, exhibition_id: exhibition_id, parent_class: "exhibition", type: 'scene' }.to_json
    post '/api/item/add', scene
  end

  def parse_response
    JSON.parse(last_response.body)
  end
end
