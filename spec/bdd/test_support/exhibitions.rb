module Page
  class Exhibitions
    include Capybara::DSL

    def initialize
      url = '/home'
      visit(url)
      validate!
    end

    def fill(field, content)
      fill_in(field, with: content, wait: 2)
    end

    def form_submit_deactivated?
      button = find('.submit')
      button.disabled?
    end

    def show
      has_css?('#action', wait: 2)
      find('#action').click
    end

    def toggle_list
      has_css?('.toggle-exhibition-list', wait: 2)
      find('.toggle-exhibition-list').click
    end

    def first_exhibition_name
      has_css?('.list-item', wait: 2)
      first('.exhibition-name').text
    end

    def save
      has_css?('.submit.cuac-exhibition-form', wait: 4)
      find('.submit.cuac-exhibition-form').click
    end

    def add_room
      click_plus_button
      item_page = Page::Item.new
      item_page.add_room
    end

    def add_item
      click_plus_button
      item_page = Page::Item.new
      item_page.add_item
    end

    def add_item_from_room
      click_plus_button
      item_page = Page::Item.new
      item_page.add_item
    end

    def click_edit
      has_css?('.edit-button', wait: 4)
      find('.edit-button').click
    end

    def view_visible?
      view = find('.view', visible: false)
      view.visible?
    end

    def form_visible?
      form = find('.form', visible: false)
      form.visible?
    end

    def exhibition_list?
      has_css?('.list-item.cuac-exhibition-detail', wait: 2)
    end

    def list_has_rooms?
      has_css?('.exhibition-room', wait: 2)
    end

    def room_has_children?
      has_css?('.exhibition-room .exhibition-scene', wait: 2)
    end

    def scene_has_children?
      has_css?('.exhibition-scene .exhibition-scene', wait: 2)
    end

    def scene_in_room_has_children?
      has_css?('.exhibition-room .exhibition-scene .exhibition-scene', wait: 2)
    end

    def list_has_scenes?
      has_css?('.exhibition-scene', wait: 2)
    end

    def room_have_plus_button?
      has_css?('.exhibition-room .plus-button', wait: 4)
    end

    def subscene_has_plus_button?
      has_css?('.exhibition-scene .exhibition-scene .plus-button', wait: 4)
    end

    def form_submit_deactivated?
      has_css?('.submit[disabled].cuac-exhibition-form')
    end

    def other_name?
      has_css?('.exhibition-name', text: 'some other name', wait: 2)
    end

    def click_plus_button
      has_css?('.plus-button', wait: 2, :text => '+')
      first('.plus-button').click
    end

    def click_room_plus_button
      has_css?('.exhibition-room .plus-button', wait: 4)
      first('.exhibition-room .plus-button').click
    end

    def click_item_plus_button
      has_css?('.exhibition-scene .plus-button', wait: 4)
      first('.exhibition-scene .plus-button').click
    end

    def click_last_item_plus_button
      has_css?('.plus-button', wait: 4)
      all('.plus-button').last.click
    end

    def go_to_exhibition_info
      has_css?('.exhibition-name', wait: 4)
      first('.exhibition-name').click
    end

    def go_to_room_info
      has_css?('.room-name', wait: 4)
      first('.room-name').click
    end

    def go_to_scene_info
      has_css?('.scene-name', wait: 4)
      first('.scene-name').click
    end

    def go_to_scene_inside_room_info
      has_css?('.item-name', wait: 4)
      first('.item-name').click
    end

    def go_to_subscene_info
      has_css?('.item-name', wait: 4)
      first('.item-name').click
    end

    def go_to_last_subscene_info
      has_css?('.item-name', wait: 4)
      all('.item-name').last.click
    end

    def go_to_subscene_info_into_room
      has_css?('.subscene-name', wait: 4)
      first('.subscene-name').click
    end

    def subscene_info?(content)
      has_css?('.exhibition-scene .exhibition-scene', wait: 4, text: content)
    end

    def room_info?(content)
      has_css?('.exhibition-room .room-name', wait: 4, text: content)
    end

    def scene_info?(content)
      has_css?('.exhibition-scene .scene-name', wait: 4, text: content)
    end

    def scene_inside_room_info?(content)
      has_css?('.exhibition-scene .item-name', wait: 4, text: content)
    end

    def title(name)
      page.has_title?(name)
    end

    def has_edit_button?
      has_css?('.edit-button')
    end

    private

    def validate!
      assert_selector('#formulary', visible: false)
      assert_selector('#action')
      assert_selector('#listing', visible: false)
      assert_selector('#result', visible: false)
      assert_selector("input[name='name']", visible: false)
      assert_selector("input[name='location']", visible: false)
    end
  end
end
