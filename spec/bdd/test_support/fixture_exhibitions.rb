require 'httparty'
require 'json'
require_relative 'fixture_museum'

module Fixture

  class Exhibitions
    extend Capybara::DSL

    SECOND_EXHIBITION = 'second name'
    NAME_FIELD = 'name'
    LOCATION_FIELD = 'location'
    NAME = 'first'
    OTHER_NAME = 'some other exhibition'
    LOCATION = 'some location'
    REDIRECTED_PAGE_TITLE = 'Item'
    LINK = 'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg'

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

      def add_museum(name, street)
        museum = { info: { name: name }, location: { street: street } }.to_json
        response = HTTParty.post('http://localhost:4567/api/museum/add', { body: museum })
        JSON.parse(response.body)['id']
      end
    end
  end


  class XExhibitions
    extend Capybara::DSL

    NAME_FIELD = 'name'
    LOCATION_FIELD = 'location'
    MUSEUM_FIELD = 'museums'
    NAME = 'some name'
    OTHER_NAME = 'some other name'
    LOCATION = 'some location'
    EXHIBITION_NAME = 'Name: some name'
    IMAGE = 'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg'
    REDIRECTED_PAGE_TITLE = 'Item'
    LINK = 'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg'

    class << self

      def pristine
        visit('/api/exhibition/flush')
        self
      end

      # def up
      #   visit('/api/exhibition/flush')
      #   visit('/api/fixtures/exhibition')
      # end

      # API/FIXTURES/EXHIBITION not yet needed !!!!


      def show_exhibition_form
        current = Page::Exhibitions.new
        current.show
        current
      end

      def fill_form
        current = Page::Exhibitions.new
        current.show

        current.fill(NAME_FIELD, NAME)
        current.select_museum(Fixture::Museum::OTHER_NAME)
        current
      end

      def exhibition_saved
        create_museums
        current = fill_form
        current.save
        current
      end

      def exhibition_edited
        current = exhibition_saved
        current.click_edit
        current.fill(NAME_FIELD, OTHER_NAME)
        current
      end

      def exhibition_saved_with_room
        current = exhibition_saved
        current.add_room
        current = Page::Exhibitions.new
        current
      end

      def exhibition_saved_with_item
        current = exhibition_saved
        current.add_item
        Page::Exhibitions.new
      end

      def exhibition_saved_with_subscenes
        Fixture::Item.from_exhibition_to_new_item

        Fixture::Item.item_saved
        Fixture::Item.item_saved_in_item

        Page::Exhibitions.new
      end

      def complete_exhibition
        current = exhibition_saved
        current.add_room
        current = Page::Exhibitions.new
        current.click_plus_button
        Page::Item.new

        Fixture::Item.item_saved
        Fixture::Item.item_saved_in_item
      end

      def two_exhibitions_introduced
        create_museums
        current = show_exhibition_form
        current.fill(NAME_FIELD, NAME)
        current.select_museum(Fixture::Museum::NAME)
        current.save

        current.show
        current.fill(NAME_FIELD, OTHER_NAME)
        current.select_museum(Fixture::Museum::OTHER_NAME)
        current.save
        current
      end

      def create_museums
        Fixture::Museum.pristine.fill_with_extra_content
        Fixture::Museum.fill_other_museum
      end
    end
  end


end
