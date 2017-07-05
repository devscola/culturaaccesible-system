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
  ITEM_NUMBERS = [1, 2, 3]
  ITEM_NUMBER_NOT_VALID = 1
  ITEM_NUMBER_VALID = 4

  it 'stores items with same exhibition id with unique items name' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_item(FIRST_NAME, exhibition_id)
    first_item_name = parse_response['name']
    first_item_exhibition_id = parse_response['parent_id']

    add_item(SECOND_NAME, exhibition_id)
    second_item_name = parse_response['name']
    second_item_exhibition_id = parse_response['parent_id']

    expect(first_item_name == second_item_name).to be false
    expect(first_item_exhibition_id == second_item_exhibition_id).to be true
  end

  it 'stores rooms' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_room(FIRST_NAME, exhibition_id)
    room_name = parse_response['name']

    expect(room_name == FIRST_NAME).to be true
  end

  it 'stores items' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_item(FIRST_NAME, exhibition_id)
    item_parent_class = parse_response['parent_class']

    expect(item_parent_class == "Exhibitions").to be true
  end

  it 'validate if item number exists' do
    add_exhibition

    exhibition = parse_response
    retrieve_exhibition(exhibition)
    exhibition_numbers = parse_response['numbers']

    expect(exhibition_numbers.include?(ITEM_NUMBER_NOT_VALID)).to be true
    expect(exhibition_numbers.include?(ITEM_NUMBER_VALID)).to be false

  end

  def add_item(unique_name, exhibition_id, number=ITEM_NUMBER_VALID)
    item = { name: unique_name, room: false, parent_id: exhibition_id, number: number, parent_class: "Exhibitions" }.to_json
    post '/api/item/add', item
  end

  def add_room(unique_name, exhibition_id)
    room = { name: unique_name, room: true, exhibition_id: exhibition_id }.to_json
    post '/api/item/add', room
  end

  def add_exhibition
    exhibition = { name: 'some name', location: 'some location', numbers: ITEM_NUMBERS }.to_json
    post '/api/exhibition/add', exhibition
  end

  def parse_response
    JSON.parse(last_response.body)
  end

  def retrieve_exhibition(exhibition)
    post '/api/exhibition/retrieve', exhibition.to_json
  end
end
