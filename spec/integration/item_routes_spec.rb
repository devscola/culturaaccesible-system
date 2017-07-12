require 'rack/test'
require 'json'
require_relative '../../system/routes/exhibitions'
require_relative '../../system/routes/items'

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
  NUMBER = 10
  ANOTHER_NUMBER = 11

  it 'stores scene with same exhibition id with unique scene name' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_scene(FIRST_NAME, exhibition_id)
    first_scene_name = parse_response['name']
    first_scene_exhibition_id = parse_response['parent_id']

    add_scene(SECOND_NAME, exhibition_id)
    second_scene_name = parse_response['name']
    second_scene_exhibition_id = parse_response['parent_id']

    expect(first_scene_name == second_scene_name).to be false
    expect(first_scene_exhibition_id == second_scene_exhibition_id).to be true
  end

  it 'stores rooms' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_room(FIRST_NAME, exhibition_id)
    room_name = parse_response['name']

    expect(room_name == FIRST_NAME).to be true
  end

  it 'cant store a room inside another room' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_room(FIRST_NAME, exhibition_id)
    room = parse_response
    room_id = parse_response['id']

    add_room_inside_a_room(SECOND_NAME, exhibition_id, room_id)

    expect(parse_response['json_class']).to eq('ArgumentError')
    expect(parse_response['m']).to eq('Creating rooms inside scenes or other rooms is not allowed')

  end

  it 'retrieve room' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_room(FIRST_NAME, exhibition_id)
    room = parse_response
    room_id = parse_response['id']
    retrieve_room(room)
    retrieved_room_id = parse_response['id']

    expect(room_id == retrieved_room_id).to be true
  end

  it 'stores scenes' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_scene(FIRST_NAME, exhibition_id)
    scene_parent_class = parse_response['parent_class']

    expect(scene_parent_class == "exhibition").to be true
  end

  it 'validate if scene number exists' do
    add_exhibition

    exhibition = parse_response
    retrieve_exhibition(exhibition)
    exhibition_numbers = parse_response['numbers']

    expect(exhibition_numbers.include?(ITEM_NUMBER_NOT_VALID)).to be true
    expect(exhibition_numbers.include?(ITEM_NUMBER_VALID)).to be false
  end

  def add_scene(unique_name, exhibition_id, number=ITEM_NUMBER_VALID)
    scene = { name: unique_name, room: false, parent_id: exhibition_id, exhibition_id: exhibition_id, number: number, parent_class: "exhibition" }.to_json
    post '/api/item/add', scene
  end

  def add_room(unique_name, exhibition_id)
    room = { name: unique_name, room: true, exhibition_id: exhibition_id, parent_id: exhibition_id, parent_class: 'exhibition', number: NUMBER }.to_json
    post '/api/item/add', room
  end

  def add_room_inside_a_room(unique_name, exhibition_id, parent_id)
    room = { name: unique_name, room: true, exhibition_id: exhibition_id, parent_id: parent_id, parent_class: 'room', number: ANOTHER_NUMBER }.to_json
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

  def retrieve_room(room)
    post 'api/room/retrieve', room.to_json
  end
end
