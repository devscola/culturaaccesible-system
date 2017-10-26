require 'rack/test'
require 'json'
require_relative '../../system/routes/exhibitions'
require_relative '../../system/routes/museums'
require_relative '../../system/exhibitions/repository'

describe 'Exhibition controller' do
  include Rack::Test::Methods

  IMAGE = 'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg'
  SPANISH = 'es'
  ENGLISH = 'en'
  CATALA = 'cat'

  def app
    App.new
  end

  before(:each) do
    Exhibitions::Repository.flush
  end

  context 'create' do
    it 'saves exhibition with selected museum' do
      add_museum
      museum_id = parse_response['id']

      add_exhibition(museum_id)
      exhibition_id = parse_response['id']
      retrieve_exhibition(exhibition_id)
      retrieved_museum = parse_response['museum']

      expect(retrieved_museum['id']).to eq museum_id
      expect(retrieved_museum['name']).to eq 'some name'
    end

    it 'saves exhibition with locales' do
      iso_codes = [SPANISH, ENGLISH]
      add_museum
      museum_id = parse_response['id']
      add_exhibition(museum_id, iso_codes)
      exhibition = parse_response

      retrieve_exhibition(exhibition['id'])
      retrieved_exhibition = parse_response

      expect(retrieved_exhibition['iso_codes'][0]).to eq SPANISH
      expect(retrieved_exhibition['iso_codes'][1]).to eq ENGLISH
    end

    it 'saves exhibition with translations' do
      iso_codes = [SPANISH, ENGLISH]
      add_museum
      museum_id = parse_response['id']
      translations = exhibition_languages

      add_exhibition(museum_id, iso_codes, translations)
      exhibition = parse_response

      expect(exhibition['translations'][0]['iso_code']).to eq SPANISH
      expect(exhibition['translations'][1]['iso_code']).to eq ENGLISH
    end

    it 'diferent exhibitions' do
      add_exhibition
      first_exhibition_id = parse_response['id']

      add_exhibition
      second_exhibition_id = parse_response['id']

      expect(first_exhibition_id == second_exhibition_id).to be false
    end
  end

  context 'retrieve' do
    it 'exhibitions with image link' do
      add_exhibition
      exhibition_id = parse_response['id']
      retrieve_exhibition(exhibition_id)
      retrieved_exhibition_id = parse_response['id']
      exhibition_image = parse_response['image']

      expect(retrieved_exhibition_id).to eq(exhibition_id)
      expect(exhibition_image).to eq(IMAGE)
    end

    it 'lists all exhibitions translated by an iso code' do
      iso_codes = [SPANISH, ENGLISH]
      spanish_name = 'nombre'
      english_name = 'name'
      first_iso_code = SPANISH
      second_iso_code = CATALA
      add_museum
      museum_id = parse_response['id']
      add_exhibition(museum_id, iso_codes, exhibition_languages)

      retrieve_translated_list(first_iso_code)
      first_translated_list = parse_response
      retrieve_translated_list(second_iso_code)
      second_translated_list = parse_response

      expect(first_translated_list[0]['name']).to eq spanish_name
      expect(second_translated_list[0]['name']).to eq spanish_name
    end

    it 'retrieves saved with translations' do
      add_translated_exhibition(exhibition_languages)
      exhibition_id = parse_response['id']

      retrieve_exhibition(exhibition_id)
      retrieved_exhibition = parse_response

      expect(retrieved_exhibition['translations'][0]['iso_code']).to eq SPANISH
      expect(retrieved_exhibition['translations'][0]['name']).to eq 'nombre'
      expect(retrieved_exhibition['translations'][0]['general_description']).to eq 'descripción corta'
      expect(retrieved_exhibition['translations'][0]['extended_description']).to eq 'descripción extendida'
      expect(retrieved_exhibition['translations'][1]['iso_code']).to eq ENGLISH
      expect(retrieved_exhibition['translations'][1]['name']).to eq 'name'
      expect(retrieved_exhibition['translations'][1]['general_description']).to eq 'short description'
      expect(retrieved_exhibition['translations'][1]['extended_description']).to eq 'extended description'
    end

    context 'items' do
      it 'of exhibition' do
        add_exhibition
        exhibition_id = parse_response['id']
        add_scene(exhibition_id)

        payload = { exhibition_id: exhibition_id }.to_json
        post '/api/exhibition/items', payload
        items = parse_response

        expect(items.any?).to be true
      end

      it 'gets an exhibition with items for sidebar' do
        add_exhibition
        exhibition_id = parse_response['id']
        add_scene(exhibition_id)

        retrieve_for_list(exhibition_id)
        result = parse_response

        expect(result['id']).to eq exhibition_id
        expect(result['children'].any?).to be true
      end

      it 'download exhibition with translated items' do
        add_exhibition
        exhibition = parse_response
        add_room('1-0-0', exhibition['id'])
        room = parse_response
        add_scene('2-0-0', exhibition['id'])
        scene = parse_response
        add_subitem('1-1-0', exhibition['id'], 'room', room['id'])
        scene_inside_room = parse_response
        add_subitem('1-1-1', exhibition['id'], 'scene', scene_inside_room['id'])
        subscene = parse_response

        retrieve_for_download(exhibition['id'], SPANISH )
        exhibition = parse_response

        expect(exhibition['items'][0]['id']).to eq room['id']
        expect(exhibition['items'][1]['id']).to eq scene['id']
        expect(exhibition['items'][0]['children'][0]['id']).to eq scene_inside_room['id']
        expect(exhibition['items'][0]['children'][0]['children'][0]['id']).to eq subscene['id']
        expect(exhibition['items'][0]['name']).to eq room['translations'][1]['name']
        expect(exhibition['items'][1]['name']).to eq scene['translations'][1]['name']
        expect(exhibition['items'][0]['children'][0]['name']).to eq scene_inside_room['translations'][1]['name']
        expect(exhibition['items'][0]['children'][0]['children'][0]['name']).to eq subscene['translations'][1]['name']
      end

      context 'oredered' do
        it 'major level list of an exhibition' do
          add_exhibition
          exhibition = parse_response
          add_scene('2-0-0', exhibition['id'])
          add_scene('1-0-0', exhibition['id'])

          retrieve_for_list(exhibition['id'])
          first_children = parse_response['children'].first

          expect(first_children).to include({'number' => '1-0-0'})
        end

        it 'minor level list of an exhibition' do
          add_exhibition
          exhibition_id = parse_response['id']
          add_scene('1-0-0', exhibition_id)
          scene = parse_response
          add_subitem('1-2-0', exhibition_id, 'scene', scene['id'])
          add_subitem('1-1-0', exhibition_id, 'scene', scene['id'])

          retrieve_for_list(exhibition_id)
          first_item_children = parse_response['children'].first['children'].first

          expect(first_item_children).to include({'number' => '1-1-0'})
        end

        it 'detail level list of an exhibition' do
          add_exhibition
          exhibition_id = parse_response['id']
          add_room('1-0-0', exhibition_id)
          room_id = parse_response['id']
          add_subitem('1-1-0', exhibition_id, 'room', room_id)
          scene_id = parse_response['id']
          add_subitem('1-1-2', exhibition_id, 'scene', scene_id)
          add_subitem('1-1-1', exhibition_id, 'scene', scene_id)

          retrieve_for_list(exhibition_id)

          first_subitem_children = parse_response['children'].first['children'].first['children'].first

          expect(first_subitem_children).to include({'number' => '1-1-1'})
        end
      end
    end
  end

  context 'updates' do
    it 'existing exhibition and translation' do
      iso_codes = [SPANISH, ENGLISH]
      add_museum
      museum_id = parse_response['id']
      translations = exhibition_languages
      add_exhibition(museum_id, iso_codes, translations)
      exhibition = parse_response
      updated_translation_id = exhibition['translations'][1]['id']

      update_exhibition(exhibition['id'], museum_id, updated_translation_id)
      retrieve_exhibition(exhibition['id'])
      retrieved_exhibition = parse_response

      expect(retrieved_exhibition['name']).to eq 'Updated english translation'
      expect(retrieved_exhibition['id'] == retrieved_exhibition['translations'][0]['exhibition_id']).to be true
      expect(retrieved_exhibition['id'] == retrieved_exhibition['translations'][1]['exhibition_id']).to be true
      expect(retrieved_exhibition['id'] == retrieved_exhibition['translations'][0]['id']).to be false
      expect(retrieved_exhibition['id'] == retrieved_exhibition['translations'][1]['id']).to be false
      expect(retrieved_exhibition['translations'][0]['iso_code']).to eq SPANISH
      expect(retrieved_exhibition['translations'][0]['name']).to eq 'nombre'
      expect(retrieved_exhibition['translations'][0]['general_description']).to eq 'descripción corta'
      expect(retrieved_exhibition['translations'][0]['extended_description']).to eq 'descripción extendida'
      expect(retrieved_exhibition['translations'][1]['iso_code']).to eq ENGLISH
      expect(retrieved_exhibition['translations'][1]['name']).to eq 'Updated name'
      expect(retrieved_exhibition['translations'][1]['general_description']).to eq 'Short description updated'
      expect(retrieved_exhibition['translations'][1]['extended_description']).to eq 'Extended description updated'
    end

    it 'retrieve the exhibition with its items' do
      iso_codes = [SPANISH, 'en']
      add_museum
      museum_id = parse_response['id']
      translations = exhibition_languages
      add_exhibition(museum_id, iso_codes, translations)
      exhibition_id = parse_response['id']
      updated_translation_id = parse_response['translations'][1]['id']
      add_scene('1-0-0', exhibition_id)

      update_exhibition(exhibition_id, museum_id, updated_translation_id)
      updated_exhibition_id = parse_response['id']
      retrieve_for_list(exhibition_id)
      first_children = parse_response['children'].first

      expect(exhibition_id == updated_exhibition_id).to be true
      expect(first_children).to include({'number' => '1-0-0'})
    end
  end

  context 'delete' do
    it 'deletes an exhibition' do
      add_exhibition
      exhibition_id = parse_response['id']

      delete_exhibition(exhibition_id)
      retrieve_list
      retrieved_list = parse_response
      exhibition_deleted = retrieved_list.include? exhibition_id

      expect(exhibition_deleted).to eq false
    end
  end


  def add_exhibition(museum_id = '', iso_codes=[], translations = exhibition_languages)
    exhibition = {
      name: 'some name',
      image: IMAGE,
      museum_id: museum_id,
      iso_codes: iso_codes,
      translations: translations
    }.to_json
    post '/api/exhibition/add', exhibition
  end

  def add_translated_exhibition(translated_languages)
    iso_codes = [SPANISH, ENGLISH]
    add_museum
    museum_id = parse_response['id']
    add_exhibition(museum_id, iso_codes, translated_languages)
    parse_response
  end

  def update_exhibition(exhibition_id, museum_id, updated_translation_id)
    exhibition_updated = {
      id: exhibition_id,
      name: 'Updated english translation',
      museum_id: museum_id,
      translations: [{
        name: 'Updated name',
        general_description: 'Short description updated',
        extended_description: 'Extended description updated',
        iso_code: ENGLISH,
        exhibition_id: exhibition_id,
        id: updated_translation_id
      }]
    }.to_json

    post '/api/exhibition/add', exhibition_updated
  end

  def retrieve_exhibition( exhibition_id )
    payload = { id: exhibition_id }.to_json
    post '/api/exhibition/retrieve', payload
  end

  def retrieve_for_list(exhibition_id)
    payload = { id: exhibition_id }.to_json
    post 'api/exhibition/retrieve-for-list', payload
  end

  def retrieve_list
    post 'api/exhibition/list'
  end

  def retrieve_translated_list(iso_code)
    payload = {iso_code: iso_code}.to_json
    post 'api/exhibition/translated-list', payload
  end

  def retrieve_for_download( exhibition_id, iso_code )
    payload = { id: exhibition_id, iso_code: iso_code }.to_json
    post '/api/exhibition/download', payload
  end

  def delete_exhibition(exhibition_id)
    payload = { id: exhibition_id }.to_json
    post '/api/exhibition/delete', payload
  end

  def add_room(number='', exhibition_id)
    room = { id: '', name: 'name', number: number, room: true, parent_id: exhibition_id, exhibition_id: exhibition_id, parent_class: "exhibition", type: 'room', translations: get_languages }.to_json
    post '/api/item/add', room
  end

  def add_scene(number='', exhibition_id)
    scene = { id: '', name: 'name', number: number, room: false, parent_id: exhibition_id, exhibition_id: exhibition_id, parent_class: "exhibition", type: 'scene', translations: get_languages }.to_json
    post '/api/item/add', scene
  end

  def add_subitem(number='', exhibition_id, parent_class, parent_id)
    scene = { id: '', name: 'name', number: number, room: false, parent_id: parent_id, exhibition_id: exhibition_id, parent_class: parent_class, type: 'scene', translations: get_languages }.to_json
    post '/api/item/add', scene
  end

  def add_museum
    museum = {
        info: {name: 'some name', description: 'some description'},
        location: {street: 'some street'}
      }.to_json
    post '/api/museum/add', museum
  end

  def get_languages
    [
      {'name' => 'name', 'description' => 'description', 'video' => 'video', 'iso_code' => ENGLISH},
      {'name' => 'nombre', 'description' => 'descripción', 'video' => 'video', 'iso_code' => SPANISH}
    ]
  end
  def exhibition_languages
    [
      {'name' => 'nombre', 'extended_description' => 'descripción extendida', 'general_description' => 'descripción corta', 'iso_code' => SPANISH},
      {'name' => 'name', 'extended_description' => 'extended description', 'general_description' => 'short description', 'iso_code' => ENGLISH}
    ]
  end

  def parse_response
    JSON.parse(last_response.body)
  end
end
