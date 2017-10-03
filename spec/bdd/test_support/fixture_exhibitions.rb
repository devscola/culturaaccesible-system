require 'httparty'
require 'json'
require_relative 'fixture_museum'

module Fixture

  class Exhibitions
    extend Capybara::DSL

    SECOND_EXHIBITION = 'second name'
    NAME_FIELD = 'name'
    DESCRIPTION_FIELD = 'extended_description'
    SHORT_DESCRIPTION_FIELD = 'general_description'
    LOCATION_FIELD = 'location'
    NAME = 'first'
    OTHER_NAME = 'some other exhibition'
    LOCATION = 'some location'
    REDIRECTED_PAGE_TITLE = 'Item'
    LINK = 'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg'

    ES_NAME_FIELD = 'name-es'
    CAT_NAME_FIELD = 'name-cat'
    CAT_DESCRIPTION_FIELD = 'extended_description-cat'
    CAT_SHORT_DESCRIPTION_FIELD = 'general_description-cat'
    ES_NAME = 'Nombre Exhibición'
    CAT_NAME = 'Nom Exhibicio'
    CAT_DESCRIPTION = 'Descripció exhibició'
    CAT_SHORT_DESCRIPTION = 'Descripció curta exhibició'
    CAT_OTHER_NAME = 'Nom actualitzat'
    CAT_OTHER_DESCRIPTION = 'Descripció actualitzada'
    CAT_OTHER_SHORT_DESCRIPTION = 'Descripció curta actualitzada'

    MUSEUM = 'Muvim'
    MUSEUM_STREET = 'Valencia'

    class << self
      def pristine
        HTTParty.get('http://localhost:4567/api/exhibition/flush')
        self
      end

      def complete_scenario
        museum_id = add_museum(MUSEUM, MUSEUM_STREET)
        exhibition_id = add_exhibition(NAME, museum_id)
        add_exhibition(SECOND_EXHIBITION, museum_id)
        add_room(exhibition_id)
        scene_id = add_scene(exhibition_id)
        add_subitem(exhibition_id, 'scene', scene_id)
      end

      def add_exhibition(name, museum_id)
        exhibition = { name: name, museum_id: museum_id, image: LINK }.to_json
        response = HTTParty.post('http://localhost:4567/api/exhibition/add', { body: exhibition })
        JSON.parse(response.body)['id']
      end

      def add_room(exhibition_id)
        room = { id: '', name: 'room', number: '1-0-0', room: true, parent_id: exhibition_id, exhibition_id: exhibition_id, parent_class: "exhibition", type: 'room' }.to_json
        HTTParty.post('http://localhost:4567/api/item/add', { body: room })
      end

      def add_scene(exhibition_id)
        scene = { id: '', name: 'scene', number: '2-0-0', room: false, parent_id: exhibition_id, exhibition_id: exhibition_id, parent_class: "exhibition", type: 'scene' }.to_json
        response = HTTParty.post('http://localhost:4567/api/item/add', { body: scene })
        JSON.parse(response.body)['id']
      end

      def add_subitem(exhibition_id, parent_class, parent_id)
        scene = { id: '', name: 'subscene', number: '2-1-0', room: false, parent_id: parent_id, exhibition_id: exhibition_id, parent_class: parent_class, type: 'scene' }.to_json
        HTTParty.post('http://localhost:4567/api/item/add', { body: scene })
      end

      def add_item(exhibition_id, parent_class, parent_id, number, item_name, type='scene', room=false)
        item = { id: '', name: item_name, number: number, room: room, parent_id: parent_id, exhibition_id: exhibition_id, parent_class: parent_class, type: type }.to_json
        response = HTTParty.post('http://localhost:4567/api/item/add', { body: item })
        JSON.parse(response.body)['id']
      end

      def add_museum(name, street)
        museum = { info: { name: name }, location: { street: street } }.to_json
        response = HTTParty.post('http://localhost:4567/api/museum/add', { body: museum })
        JSON.parse(response.body)['id']
      end
    end
  end
end
