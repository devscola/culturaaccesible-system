require 'httparty'
require 'json'
require_relative 'fixture_museum'
require_relative 'fixture_exhibitions'
require_relative 'item'

module Fixture
  class Item
    extend Capybara::DSL

    ERROR_LENGTH_DATE = '19865'
    ROOM_NAME = 'Room artworks'
    DATE = '1937'
    AUTHOR = 'Picasso'
    ARTWORK = 'Guernica'
    OTHER_ARTWORK = 'La costellazione'
    VISIBLE_ARTWORK = 'Name: Guernica'
    VISIBLE_OTHER_ARTWORK = 'Name: La costellazione'
    VISIBLE_AUTHOR = 'Author: Picasso'
    FIRST_NUMBER = '1-0-0'
    SECOND_NUMBER = '2-0-0'
    THIRD_NUMBER = '3-0-0'
    INFO_FIRST_NUMBER = 'Number: 1'
    INFO_SECOND_NUMBER = 'Number: 2'
    INFO_THIRD_NUMBER = 'Number: 3'
    REPEATED_NUMBER = FIRST_NUMBER
    SAVE_BUTTON = 'Save'

    class << self
      def pristine
        Fixture::Exhibitions.pristine
        Fixture::Museum.pristine
      end

      def complete_scenario
        pristine
        create_complete_exhibition(Fixture::Exhibitions::NAME, '1')
      end

      def create_a_room_with_alert
        current = Page::Item.new
        current.fill('name',Fixture::Item::ARTWORK)
        current.fill('author', Fixture::Item::AUTHOR)
        current.fill('date', Fixture::Item::DATE)
        current.check_room
        current
      end

      def create_complete_exhibition(exhibition_name,exhibition_order)
        museum_id = Fixture::Exhibitions.add_museum(Fixture::Exhibitions::MUSEUM, Fixture::Exhibitions::MUSEUM_STREET)
        exhibition_id = Fixture::Exhibitions.add_exhibition(exhibition_name, museum_id)
        room_id = Fixture::Exhibitions.add_item(exhibition_id, 'exhibition', exhibition_id, exhibition_order + '-0-0', 'room', 'room', true)
        scene_id = Fixture::Exhibitions.add_item(exhibition_id, 'room', room_id, exhibition_order + '-1-0', 'scene', 'scene', false)
        subscene_id = Fixture::Exhibitions.add_item(exhibition_id, 'scene', scene_id, exhibition_order + '-1-1', 'subscene', 'scene', false)
      end

      def go_to_room_info
        has_css?('.room-name', wait: 4)
        first('.room-name', wait: 4).click
      end
    end
  end
end
