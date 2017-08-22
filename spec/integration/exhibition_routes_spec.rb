require 'rack/test'
require 'json'
require_relative '../../system/routes/exhibitions'
require_relative '../../system/routes/museums'
require_relative '../../system/exhibitions/repository'

describe 'Exhibition controller' do
  include Rack::Test::Methods

  IMAGE = 'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg'


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

  it 'retrieves required exhibition with image link' do
    add_exhibition
    exhibition_id = parse_response['id']
    payload = { id: exhibition_id }.to_json
    post '/api/exhibition/retrieve', payload
    retrieved_exhibition_id = parse_response['id']
    exhibition_image = parse_response['image']

    expect(retrieved_exhibition_id).to eq(exhibition_id)
    expect(exhibition_image).to eq(IMAGE)
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

    add_scene(exhibition_id)

    post '/api/exhibition/items', payload

    result = parse_response

    expect(result.any?).to be true
  end

  it 'retrieves an exhibition and children for sidebar' do
    add_exhibition
    exhibition_id = parse_response['id']
    payload = { id: exhibition_id }.to_json

    add_scene(exhibition_id)

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
      museum_id: '1'
    }.to_json
    post '/api/exhibition/add', exhibition_updated
    payload = { id: exhibition_id }.to_json
    post '/api/exhibition/retrieve', payload

    result = parse_response['name']
    expect(result).to eq 'some other name'
  end

  it 'retrieve ordered major level list of an exhibition' do
    add_exhibition
    exhibition = parse_response
    scene = add_scene('2-0-0', exhibition['id'])
    other_scene = add_scene('1-0-0', exhibition['id'])

    retrieve_for_list(exhibition['id'])
    first_children = parse_response['children'].first

    expect(first_children).to include({'number' => '1-0-0'})
  end

  it 'retrieve ordered minor level list of an exhibition' do
    add_exhibition
    exhibition = parse_response
    add_scene('1-0-0', exhibition['id'])
    scene = parse_response
    subscene_into_scene = add_subitem('1-2-0', exhibition['id'], 'scene', scene['id'])
    other_subscene_into_scene = add_subitem('1-1-0', exhibition['id'], 'scene', scene['id'])

    retrieve_for_list(exhibition['id'])
    first_item_children = parse_response['children'].first['children'].first

    expect(first_item_children).to include({'number' => '1-1-0'})
  end

  it 'retrieve ordered detail level list of an exhibition' do
    add_exhibition
    exhibition = parse_response
    add_room('1-0-0', exhibition['id'])
    room = parse_response
    add_subitem('1-1-0', exhibition['id'], 'room', room['id'])
    scene = parse_response
    add_subitem('1-1-2', exhibition['id'], 'scene', scene['id'])
    add_subitem('1-1-1', exhibition['id'], 'scene', scene['id'])

    retrieve_for_list(exhibition['id'])

    first_subitem_children = parse_response['children'].first['children'].first['children'].first

    expect(first_subitem_children).to include({'number' => '1-1-1'})
  end

  it 'retrieve an updated exhibition with item' do
    add_exhibition
    exhibition = parse_response
    add_scene('1-0-0', exhibition['id'])

    exhibition_updated = {
      id: exhibition['id'],
      name: 'some other name',
      museum_id: '1',
      image: 'fake-image.jpg'
    }.to_json
    post '/api/exhibition/add', exhibition_updated
    updated_exhibition = parse_response

    retrieve_for_list(exhibition['id'])
    first_children = parse_response['children'].first

    expect(exhibition['id'] == updated_exhibition['id']).to be true
    expect(first_children).to include({'number' => '1-0-0'})
  end

  it 'deletes an exhibition' do
    add_exhibition
    exhibition_id = parse_response['id']

    delete_exhibition(exhibition_id)

    retrieve_list
    result = parse_response

    exhibition_deleted = result.select { |exhibition| exhibition['id'] == exhibition_id }.length == 0

    expect(exhibition_deleted).to eq true
  end

  it 'saves exhibition with museum relationship' do
    add_museum
    museum_id = parse_response['id']
    add_exhibition(museum_id)
    exhibition = parse_response

    payload = { id: exhibition['id'] }.to_json
    post '/api/exhibition/retrieve', payload

    retrieved_museum_id = parse_response['museum_id']
    expect(retrieved_museum_id).to eq museum_id
  end

  def retrieve_for_list(exhibition_id)
    payload = { id: exhibition_id }.to_json
    post 'api/exhibition/retrieve-for-list', payload
  end

  def retrieve_list
    post 'api/exhibition/list'
  end

  def add_exhibition(museum_id = '')
    exhibition = {
      name: 'some name',
      image: IMAGE,
      museum_id: museum_id
    }.to_json
    post '/api/exhibition/add', exhibition
  end

  def delete_exhibition(exhibition_id)
    payload = { id: exhibition_id }.to_json
    post '/api/exhibition/delete', payload
  end

  def add_room(number='', exhibition_id)
    room = { id: '', name: 'name', number: number, room: true, parent_id: exhibition_id, exhibition_id: exhibition_id, parent_class: "exhibition", type: 'room' }.to_json
    post '/api/item/add', room
  end

  def add_scene(number='', exhibition_id)
    scene = { id: '', name: 'name', number: number, room: false, parent_id: exhibition_id, exhibition_id: exhibition_id, parent_class: "exhibition", type: 'scene' }.to_json
    post '/api/item/add', scene
  end

  def add_subitem(number='', exhibition_id, parent_class, parent_id)
    scene = { id: '', name: 'name', number: number, room: false, parent_id: parent_id, exhibition_id: exhibition_id, parent_class: parent_class, type: 'scene' }.to_json
    post '/api/item/add', scene
  end

  def add_museum
    museum = {
        info: {name: 'some name', description: 'some description'},
        location: {street: 'some street'}
      }.to_json
    post '/api/museum/add', museum
  end

  def parse_response
    JSON.parse(last_response.body)
  end
end
