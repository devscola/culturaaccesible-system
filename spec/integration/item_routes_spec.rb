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
  AUTHOR = 'author name'
  IMAGE = "https://s3.amazonaws.com/pruebas-cova/girasoles.jpg"
  VIDEO = 'https://s3.amazonaws.com/pruebas-cova/3minutes.mp4'
  DATE = '2017'

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
    image = parse_response['image']
    video = parse_response['video']

    expect(room_name == FIRST_NAME).to be true
    expect(image == IMAGE).to be true
    expect(video == VIDEO).to be true
  end

  it 'cant store a room inside another room' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_room(FIRST_NAME, exhibition_id)
    room_id = parse_response['id']

    add_room_inside_a_room(SECOND_NAME, exhibition_id, room_id)

    expect(parse_response['json_class']).to eq('ArgumentError')
    expect(parse_response['m']).to eq('Store or update item error')

  end

  it 'cant update a room into a scene' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_room(FIRST_NAME, exhibition_id)
    room_id = parse_response['id']
    room_number = parse_response['number']
    check_room = false
    update_room(room_id, exhibition_id, room_number, check_room)

    expect(parse_response['json_class']).to eq('ArgumentError')
    expect(parse_response['m']).to eq('Updating room not allows changing it to scene')
  end

  it 'cant update a scene into a room' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_scene(FIRST_NAME, exhibition_id, NUMBER)
    scene_id = parse_response['id']
    scene_number = parse_response['number']
    check_room = true
    update_scene(scene_id, exhibition_id, scene_number, check_room)

    expect(parse_response['json_class']).to eq('ArgumentError')
    expect(parse_response['m']).to eq('Store or update item error')
  end

  it 'retrieve room' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_room(FIRST_NAME, exhibition_id)
    room_id = parse_response['id']
    retrieve_room(room_id, exhibition_id)
    retrieved_room_id = parse_response['id']

    expect(room_id == retrieved_room_id).to be true
  end

  it 'stores scenes' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_scene(FIRST_NAME, exhibition_id)
    scene_parent_class = parse_response['parent_class']
    image = parse_response['image']
    video = parse_response['video']

    expect(scene_parent_class == "exhibition").to be true
    expect(image == IMAGE).to be true
    expect(video == VIDEO).to be true
  end

  it 'creates a scene with author and date' do
    add_exhibition

    exhibition_id = parse_response['id']

    add_scene(FIRST_NAME, exhibition_id, NUMBER)
    scene_author = parse_response['author']
    scene_date = parse_response['date']

    expect(scene_author).to eq AUTHOR
    expect(scene_date).to eq DATE
  end

  it 'updates rooms' do
    add_exhibition

    exhibition = parse_response
    exhibition_id = parse_response['id']

    add_room(FIRST_NAME, exhibition_id)
    room_id = parse_response['id']
    room_number = parse_response['number']
    update_room(room_id, exhibition_id, room_number)
    updated_room_id = parse_response['id']

    retrieve_exhibition(exhibition)

    expect(room_id == updated_room_id).to be true
  end

  it 'updates scene' do
    add_exhibition

    exhibition = parse_response
    exhibition_id = parse_response['id']


    add_scene(FIRST_NAME, exhibition_id, NUMBER)
    scene_id = parse_response['id']
    scene_number = parse_response['number']
    update_scene(scene_id, exhibition_id, scene_number)
    updated_scene_id = parse_response['id']

    retrieve_exhibition(exhibition)

    expect(scene_id == updated_scene_id).to be true
  end

  it 'retrieve next order number for first level item' do
    add_exhibition
    exhibition_id = parse_response['id']

    request_body = {
      exhibition_id: exhibition_id,
      parent_id: exhibition_id,
      parent_class: 'exhibition'
    }.to_json
    post '/api/exhibition/retrieve-next-ordinal', request_body

    result = parse_response['next_child']
    expect(result).to eq('1-0-0')
  end

  it 'retrieve next order number for second level item' do
    add_exhibition
    exhibition_id = parse_response['id']

    request_body = {
      exhibition_id: exhibition_id,
      parent_id: exhibition_id,
      parent_class: 'exhibition'
    }.to_json
    post '/api/exhibition/retrieve-next-ordinal', request_body
    result = parse_response['next_child']

    add_room(FIRST_NAME, exhibition_id, '1-0-0')
    room_id = parse_response['id']
    request_body = {
      exhibition_id: exhibition_id,
      parent_id: room_id,
      parent_class: 'room'
    }.to_json
    post '/api/exhibition/retrieve-next-ordinal', request_body
    result = parse_response['next_child']

    expect(result).to eq('1-1-0')
  end

  it 'deletes a room and its children' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_room(FIRST_NAME, exhibition_id, '1-0-0')
    room_id = parse_response['id']

    add_scene(SECOND_NAME, exhibition_id, '1-1-0', room_id)
    scene_id = parse_response['id']

    add_scene(SECOND_NAME, exhibition_id, '1-1-1', scene_id)
    subscene_id = parse_response['id']

    delete_item(room_id, exhibition_id)

    retrieve_room(room_id, exhibition_id)
    retrieved_id = parse_response['id']

    expect(retrieved_id).to eq nil

    retrieve_scene(scene_id, exhibition_id)
    retrieved_id = parse_response['id']

    expect(retrieved_id).to eq nil

    retrieve_scene(subscene_id, exhibition_id)
    retrieved_id = parse_response['id']

    expect(retrieved_id).to eq nil
  end

  it 'saved scene is received with translations' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_scene(FIRST_NAME, exhibition_id)

    translations = parse_response['translations']

    expect(translations[0]['name']).to eq 'name'
    expect(translations[1]['name']).to eq 'nombre'
  end

  it 'updated scene is received with translations' do
    add_exhibition
    exhibition_id = parse_response['id']

    add_scene(FIRST_NAME, exhibition_id)

    translations = parse_response['translations']
    translation_id = translations[0]['id']
    scene_id = parse_response['id']
    scene_number = parse_response['number']

    translations[0]['name'] = 'updated name'

    update_scene(scene_id, exhibition_id, scene_number, false, translations)
    translations = parse_response['translations']

    expect(translations[0]['name']).to eq 'updated name'
    expect(translations[1]['name']).to eq 'nombre'
    expect(translation_id).to eq translations[0]['id']
  end

  def add_scene(unique_name, exhibition_id, number=ITEM_NUMBER_VALID, parent_id=exhibition_id)
    scene = {
      id: '',
      name: unique_name,
      room: false,
      parent_id: parent_id,
      exhibition_id: exhibition_id,
      number: number,
      image: IMAGE,
      video: VIDEO,
      parent_class: "exhibition",
      type: 'scene',
      author: AUTHOR,
      date: DATE,
      translations: get_languages
    }.to_json

    post '/api/item/add', scene
  end

  def add_room(unique_name, exhibition_id, number = NUMBER)
    room = {
      id: '',
      name: unique_name,
      room: true,
      image: IMAGE,
      video: VIDEO,
      exhibition_id: exhibition_id,
      parent_id: exhibition_id,
      parent_class: 'exhibition',
      number: number,
      type: 'room',
    }.to_json

    post '/api/item/add', room
  end

  def add_room_inside_a_room(unique_name, exhibition_id, parent_id)
    room = { id: '', name: unique_name, room: true, exhibition_id: exhibition_id,
      parent_id: parent_id, parent_class: 'room', number: ANOTHER_NUMBER, type: 'room' }.to_json
    post '/api/item/add', room
  end

  def add_exhibition
    exhibition = { name: 'some name', location: 'some location' }.to_json
    post '/api/exhibition/add', exhibition
  end

  def parse_response
    JSON.parse(last_response.body)
  end

  def retrieve_exhibition(exhibition)
    post '/api/exhibition/retrieve', exhibition.to_json
  end

  def retrieve_room(room_id, exhibition_id)
    payload = { id: room_id, exhibition_id: exhibition_id }.to_json
    post 'api/item/retrieve', payload
  end

  def retrieve_scene(id, exhibition_id)
    payload = { id: id, exhibition_id: exhibition_id }.to_json
    post 'api/item/retrieve', payload
  end

  def update_room(id, exhibition_id, room_number, check_room = true)
    room = { id: id, name: FIRST_NAME, room: check_room, exhibition_id: exhibition_id, parent_id: exhibition_id, parent_class: 'exhibition', number: ANOTHER_NUMBER, last_number: room_number, type: 'room' }.to_json
    post '/api/item/update', room
  end

  def update_scene(id, exhibition_id, scene_number, check_room = false, languages = [])
    scene = { id: id, name: FIRST_NAME, room: check_room, exhibition_id: exhibition_id, parent_id: exhibition_id, parent_class: 'exhibition', number: ANOTHER_NUMBER, last_number: scene_number, type: 'scene', translations: languages }.to_json
    post '/api/item/update', scene
  end

  def delete_item(id, exhibition_id)
    payload = { id: id, exhibition_id: exhibition_id }.to_json
    post '/api/item/delete', payload
  end

  def get_languages
    [
      {'name' => 'name', 'description' => 'description', 'video' => 'video', 'iso_code' => 'en'},
      {'name' => 'nombre', 'description' => 'descripción', 'video' => 'video', 'iso_code' => 'es'}
    ]
  end

end
