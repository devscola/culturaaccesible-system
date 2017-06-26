require 'rack/test'
require 'json'
require_relative '../../system/exhibitions/routes'
require_relative '../../system/items/routes'

describe 'Item controller' do
include Rack::Test::Methods

  def app
    App.new
  end 

  FIRST_NAME = 'first item name'
  SECOND_NAME = 'second item name'

  it 'stores items with same exhibition id with unique items name' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_item(FIRST_NAME, exhibition_id)
    first_item_name = parse_response['name']
    first_item_exhibition_id = parse_response['exhibition_id']

    add_item(SECOND_NAME, exhibition_id)
    second_item_name = parse_response['name']
    second_item_exhibition_id = parse_response['exhibition_id']

    expect(first_item_name == second_item_name).to be false
    expect(first_item_exhibition_id == second_item_exhibition_id).to be true
  end

  def add_item(unique_name, exhibition_id)
    item = { name: unique_name, exhibition_id: exhibition_id }.to_json
    post '/api/item/add', item
  end

  def add_exhibition
    exhibition = { name: 'some name', location: 'some location' }.to_json
    post '/api/exhibition/add', exhibition
  end

  def parse_response
    JSON.parse(last_response.body)
  end
end
