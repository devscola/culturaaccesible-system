require 'rack/test'
require 'json'
require 'httparty'
require_relative '../../system/routes/exhibitions'
require_relative '../../system/routes/items'

describe 'Item controller'  do
  include Rack::Test::Methods

  def app
    App.new
  end

  let(:exhibition) { add_exhibition }

  FIRST_NAME = 'first item name'
  SECOND_NAME = 'second item name'
  UPDATED_NAME = 'updated name'
  ITEM_NUMBERS = [1, 2, 3]
  ITEM_NUMBER_NOT_VALID = 1
  ITEM_NUMBER_VALID = 4
  NUMBER = '10-0-0'
  ANOTHER_NUMBER = '11-0-0'
  AUTHOR = 'author name'
  IMAGE = "https://s3.amazonaws.com/pruebas-cova/girasoles.jpg"
  VIDEO = 'https://s3.amazonaws.com/pruebas-cova/3minutes.mp4'
  DATE = '2017'

  context 'creating' do

    it 'stores scenes' do
      add_scene(FIRST_NAME, exhibition['id'])
      scene = parse_response

      expect(scene['parent_class'] == "exhibition").to be true
      expect(scene['image'] == IMAGE).to be true
      expect(scene['video'] == VIDEO).to be true
    end

    it 'stores a scene with author and date' do
      add_scene(FIRST_NAME, exhibition['id'], NUMBER)
      scene_author = parse_response['author']
      scene_date = parse_response['date']

      expect(scene_author).to eq AUTHOR
      expect(scene_date).to eq DATE
    end

    it 'stores scenes with same exhibition id with unique scene name' do
      add_scene(FIRST_NAME, exhibition['id'], '1-0-0')
      first_scene_name = parse_response['name']
      first_scene_exhibition_id = parse_response['parent_id']
      add_scene(SECOND_NAME, exhibition['id'], '2-0-0')
      second_scene_name = parse_response['name']
      second_scene_exhibition_id = parse_response['parent_id']

      expect(first_scene_name == second_scene_name).to be false
      expect(first_scene_exhibition_id == second_scene_exhibition_id).to be true
    end

    it 'stores scenes with same number raises a exception' do
      add_scene(FIRST_NAME, exhibition['id'], '1-0-0')
      add_scene(SECOND_NAME, exhibition['id'], '1-0-0')

      expect(parse_response['json_class']).to eq('RuntimeError')
      expect(parse_response['m']).to eq('Store or update item number error, number allready exist')
    end

    it 'stores rooms' do
      add_room(FIRST_NAME, exhibition['id'])
      room = parse_response

      expect(room['name'] == FIRST_NAME).to be true
      expect(room['image'] == IMAGE).to be true
      expect(room['video'] == VIDEO).to be true
    end

    it 'cant store a room inside another room' do
      add_room(FIRST_NAME, exhibition['id'])
      room_id = parse_response['id']
      add_room_inside_a_room(SECOND_NAME, exhibition['id'], room_id)

      expect(parse_response['json_class']).to eq('ArgumentError')
      expect(parse_response['m']).to eq('Store or update item error')
    end
  end

  context 'retrieving' do
    it 'room' do
      add_room(FIRST_NAME, exhibition['id'])
      room_id = parse_response['id']

      retrieve_item(room_id, exhibition['id'])
      retrieved_room_id = parse_response['id']

      expect(room_id == retrieved_room_id).to be true
    end

    it 'with translations' do
      add_scene(FIRST_NAME, exhibition['id'])
      translations = parse_response['translations']

      expect(translations[0]['name']).to eq 'name'
      expect(translations[1]['name']).to eq 'nombre'
    end

    context 'ordering' do
      it 'retrieve next order number for first level item' do
        retrieve_next_ordinal(exhibition['id'], exhibition['id'])
        order = parse_response['next_child']

        expect(order).to eq('1-0-0')
      end
      it 'retrieve next order number for second level item' do
        retrieve_next_ordinal(exhibition['id'], exhibition['id'])

        add_room(FIRST_NAME, exhibition['id'], '1-0-0')
        room_id = parse_response['id']
        retrieve_next_ordinal(exhibition['id'], room_id, 'room')
        order = parse_response['next_child']

        expect(order).to eq('1-1-0')
      end
    end
  end

  context 'updating' do
    it 'rooms' do
      add_room(FIRST_NAME, exhibition['id'])
      room_id = parse_response['id']
      room_number = parse_response['number']

      update_room(room_id, exhibition['id'], room_number)
      updated_room_id = parse_response['id']

      expect(room_id == updated_room_id).to be true
    end

    it 'scenes' do
      add_scene(FIRST_NAME, exhibition['id'], NUMBER)
      scene_id = parse_response['id']
      scene_number = parse_response['number']

      update_scene(scene_id, exhibition['id'], scene_number)
      updated_scene_id = parse_response['id']
      expect(scene_id == updated_scene_id).to be true
    end

    it 'scene updates order too' do
      add_scene(FIRST_NAME, exhibition['id'], NUMBER)
      scene_id = parse_response['id']

      update_scene(scene_id, exhibition['id'], NUMBER)
      retrieve_exhibition(exhibition)
      exhibition = parse_response
      number = exhibition['order']['index'].key(scene_id)

      expect(number == ANOTHER_NUMBER).to be true
    end

    it 'scene is received with translations' do
      add_scene(FIRST_NAME, exhibition['id'])
      translations = parse_response['translations']
      translation_id = translations[0]['id']
      scene_id = parse_response['id']
      scene_number = parse_response['number']
      translations[0]['name'] = UPDATED_NAME

      update_scene(scene_id, exhibition['id'], scene_number, false, translations)
      translations = parse_response['translations']

      expect(translations[0]['name']).to eq UPDATED_NAME
      expect(translations[1]['name']).to eq 'nombre'
      expect(translation_id).to eq translations[0]['id']
    end

      it 'cant updates a room into a scene' do
        add_room(FIRST_NAME, exhibition['id'])
        room_id = parse_response['id']
        room_number = parse_response['number']
        check_room = false

        update_room(room_id, exhibition['id'], room_number, check_room)

        expect(parse_response['json_class']).to eq('ArgumentError')
        expect(parse_response['m']).to eq('Updating room not allows changing it to scene')
      end

      it 'cant updates a scene into a room' do
        add_scene(FIRST_NAME, exhibition['id'], NUMBER)
        scene_id = parse_response['id']
        scene_number = parse_response['number']
        check_room = true

        update_scene(scene_id, exhibition['id'], scene_number, check_room)

        expect(parse_response['json_class']).to eq('ArgumentError')
        expect(parse_response['m']).to eq('Store or update item error')
      end
  end

  context 'deleting' do
    it 'deletes a room and its children' do
      add_room(FIRST_NAME, exhibition['id'], '1-0-0')
      room_id = parse_response['id']
      add_scene(SECOND_NAME, exhibition['id'], '1-1-0', room_id)
      scene_id = parse_response['id']
      add_scene(SECOND_NAME, exhibition['id'], '1-1-1', scene_id)
      subscene_id = parse_response['id']

      delete_item(room_id, exhibition['id'])
      retrieve_item(room_id, exhibition['id'])
      retrieved_room_id = parse_response['id']
      retrieve_item(scene_id, exhibition['id'])
      first_scene_id = parse_response['id']
      retrieve_item(subscene_id, exhibition['id'])
      second_scene_id = parse_response['id']

      expect(retrieved_room_id).to eq nil
      expect(first_scene_id).to eq nil
      expect(second_scene_id).to eq nil
    end
  end

  context 'sidebar' do
    it 'not retrieve delete item' do
      add_room(FIRST_NAME, exhibition['id'], '1-0-0')
      room_id = parse_response['id']
      add_scene(SECOND_NAME, exhibition['id'], '1-1-0', room_id)
      scene_id = parse_response['id']
      add_scene(SECOND_NAME, exhibition['id'], '1-1-1', scene_id)

      delete_item(scene_id, exhibition['id'])

      retrive_by_exhibition(exhibition)

      exhibition_list = parse_response

      expect(exhibition_list['children'][0]['id']).to eq room_id
      expect(exhibition_list['children'][0]['children'].size).to eq 0
    end
    it 'can add items after delete' do
      add_room(FIRST_NAME, exhibition['id'], '1-0-0')
      room_id = parse_response['id']
      add_scene(SECOND_NAME, exhibition['id'], '1-1-0', room_id)
      scene_id = parse_response['id']
      add_scene(SECOND_NAME, exhibition['id'], '1-1-1', scene_id)

      retrive_by_exhibition(exhibition)
      exhibition_list = parse_response

      expect(exhibition_list['children'][0]['children'][0]['children'].size).to eq 1

      delete_item(scene_id, exhibition['id'])

      add_scene(SECOND_NAME, exhibition['id'], '1-1-0', room_id)
      scene_id = parse_response['id']

      retrive_by_exhibition(exhibition)
      exhibition_list = parse_response

      expect(exhibition_list['children'][0]['id']).to eq room_id
      expect(exhibition_list['children'][0]['children'].size).to eq 1
      expect(exhibition_list['children'][0]['children'][0]['children'].size).to eq 0
    end
  end

  def add_exhibition
    HTTParty.get('http://localhost:4567/api/exhibition/flush')
    exhibition = { name: 'some name', location: 'some location' }.to_json
    post '/api/exhibition/add', exhibition
    parse_response
  end

  def retrive_by_exhibition exhibition
    post '/api/exhibition/retrieve-for-list', exhibition.to_json
  end

  def add_scene(unique_name, exhibition_id, number=ITEM_NUMBER_VALID, parent_id = nil)
    parent_id = exhibition_id if parent_id.nil?
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

  def retrieve_exhibition(exhibition)
    post '/api/exhibition/retrieve', exhibition.to_json
  end

  def retrieve_item(id, exhibition_id)
    payload = { id: id, exhibition_id: exhibition_id }.to_json
    post 'api/item/retrieve', payload
  end

  def retrieve_next_ordinal(exhibition_id, parent_id, parent_class = 'exhibition')
    request_body = {
      exhibition_id: exhibition_id,
      parent_id: parent_id,
      parent_class: parent_class
    }.to_json
    post '/api/exhibition/retrieve-next-ordinal', request_body
  end

  def update_room(id, exhibition_id, last_room_number, check_room = true)
    room = { id: id, name: FIRST_NAME, room: check_room, exhibition_id: exhibition_id, parent_id: exhibition_id, parent_class: 'exhibition', number: ANOTHER_NUMBER, last_number: last_room_number, type: 'room' }.to_json
    post '/api/item/update', room
  end

  def update_scene(id, exhibition_id, last_scene_number, check_room = false, languages = [])
    scene = { id: id, name: FIRST_NAME, room: check_room, exhibition_id: exhibition_id, parent_id: exhibition_id, parent_class: 'exhibition', number: ANOTHER_NUMBER, last_number: last_scene_number, type: 'scene', translations: languages }.to_json
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

  def parse_response
    JSON.parse(last_response.body)
  end

end
