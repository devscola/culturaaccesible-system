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

    def content?(content)
      has_content?(content, wait: 1)
    end

    def toggle_list
      if(!has_css?('.glyphicon.glyphicon-list.toggle-exhibition-list', wait: 4).nil?)
        first('.glyphicon.glyphicon-list.toggle-exhibition-list', wait: 4).click
      end
    end

    def has_toggle?
      has_css?('.toggle-exhibition-list', wait: 2)
    end

    def first_exhibition_name
      has_css?('.list-item', wait: 4)
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
      has_css?('.edit-button',  exact_text: 'Edit', wait: 4)
      find('.edit-button').click
    end

    def click_delete
      has_css?('.delete-button',  exact_text: 'Delete', wait: 4)
      find('.delete-button').click
    end

    def view_visible?
      has_css?('.view', wait: 6, visible: false)
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

    def sidebar_has_museums?
      has_css?('.museum-name', wait: 4)
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
      has_css?('.exhibition-room .plus-button', wait: 4, exact_text: '+')
    end

    def subscene_has_plus_button?
      has_css?('.exhibition-scene .exhibition-scene .plus-button', wait: 4)
    end

    def form_submit_deactivated?
      has_css?('.submit[disabled].cuac-exhibition-form')
    end

    def other_name?
      has_css?('.exhibition-name', exact_text: 'some other name', wait: 2)
    end

    def click_plus_button
      if(!has_css?('.plus-button', wait: 4, exact_text: '+').nil?)
        first('.plus-button', wait: 4, exact_text: '+').click
      end
    end

    def click_room_plus_button
      if(!has_css?('.exhibition-room .plus-button', wait: 4, exact_text: '+').nil?)
        first('.exhibition-room .plus-button', wait: 4, exact_text: '+').click
      end
    end

    def click_item_plus_button
      if(!has_css?('.exhibition-scene .plus-button', wait: 4, exact_text: '+').nil?)
        first('.exhibition-scene .plus-button', wait: 4, exact_text: '+').click
      end
    end

    def click_last_item_plus_button
      if(!has_css?('.plus-button', wait: 4, exact_text: '+').nil?)
        all('.plus-button', wait: 4, exact_text: '+').last.click
      end
    end

    def go_to_exhibition_info
      has_css?('.exhibition-name', wait: 4)
      first('.exhibition-name', wait: 4).click
    end

    def go_to_room_info
      has_css?('.room-name', wait: 4)
      first('.room-name', wait: 4).click
    end

    def go_to_scene_info
      has_css?('.scene-name', wait: 4)
      first('.scene-name', wait: 4).click
    end

    def go_to_scene_inside_room_info
      has_css?('.item-name', wait: 4)
      first('.item-name', wait: 4).click
    end

    def go_to_subscene_info
      has_css?('.item-name', wait: 4)
      first('.item-name', wait: 4).click
    end

    def go_to_last_subscene_info
      has_css?('.item-name', wait: 4)
      all('.item-name', wait: 4).last.click
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
      has_css?('.edit-button', wait: 4, exact_text: 'Edit')
    end

    def save_exhibition_with_museum(museum)
      fill(Fixture::Exhibitions::NAME_FIELD, Fixture::Exhibitions::NAME)
      select_museum(museum)
      save
    end

    def view_has_museum?(museum)
      has_css?('.museum', wait: 4, text: museum, visible: true)
    end

    def select_museum(name)
      find('#museums').click
      find('#museums option', text: name).click
    end
    private

    def validate!
      assert_selector('#formulary', visible: false)
      assert_selector('#action')
      assert_selector('#listing', visible: false)
      assert_selector('#result', visible: false)
      assert_selector("input[name='name']", visible: false)
      assert_selector("select[name='museums']", visible: false)
    end
  end
end
