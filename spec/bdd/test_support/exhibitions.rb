module Page
  class Exhibitions
    include Capybara::DSL

    def initialize
      url = '/home'
      visit(url)
      validate!
    end

    def click_exhibition(exhibition)
      has_css?('.exhibition-name', exact_text: exhibition, wait: 4, visible: true)
      first('.exhibition-name', exact_text: exhibition, wait: 4).click
    end

    def click_exhibition_name(exhibition_name)
      has_css?('.exhibition-name', wait: 4)
      first('.exhibition-name', text: exhibition_name, wait: 4).click
    end

    def click_edit
      has_css?('.edit-button', wait: 4)
      first('.edit-button', exact_text: 'Edit', wait: 4).click
    end

    def toggle_list
      has_sidebar?
      first('.toggle-exhibition-list', wait: 4, visible: true).click
    end

    def has_sidebar?
      has_css?('.toggle-exhibition-list', wait: 4, visible: true)
    end

    def click_plus_button
      has_css?('.plus-button', wait: 10, text: '+', visible: true)
      first('.plus-button', wait: 4, text: '+', visible: true).click
    end

    def click_in_exhibition_plus_button
      has_css?('.edit-button', wait: 4, visible: true)
      first('.cuac-sidebar-plus-button', wait: 4, visible: true).click
    end

    def go_to_exhibition_info(exhibition)
      has_css?('.exhibition-name', wait: 10, visible: true, text: exhibition)
      first('.exhibition-name', text: exhibition, wait: 4, visible: true).click
    end

    def sidebar_has_museums?
      has_css?('.museum-name', wait: 4, visible: true)
    end

    def go_to_museum_info
      has_css?('.museum-name', wait: 4, visible: true)
      first('.museum-name', wait: 4).click
    end

    def has_new_exhibition_button?
      has_css?('.add-exhibition-button', wait: 4, visible: true)
    end

    def has_new_museum_button?
      has_css?('#newMuseum', wait: 4, visible: true)
    end

    def save
      has_css?('.submit', exact_text: 'Save', wait: 4, visible: true)
      first('.submit', exact_text: 'Save', wait: 4, visible: true).click
      self
    end

    def submit
      find('.submit').click
    end

    def go_to_last_room_info
      all('.room-name', wait: 4, visible: true).last.click
    end

    def find_content(selector)
      all(selector).last.text
    end

    def name?(name)
      has_css?('.exhibition-name', exact_text: name, wait: 4)
    end

    def view_has_museum?(museum)
      has_css?('.museum', wait: 4, text: museum, visible: true)
    end

    def click_delete_button
      has_css?('.delete-button', wait: 4)
      find('.delete-button', text: 'Delete', wait: 4).click
    end

    def accept_alert
      has_css?('.accept-alert', wait: 4)
      find('.accept-alert', text: 'OK').click
    end

    def fill(field, content)
      fill_in(field, with: content, wait: 2)
    end

    def fill_mandatory_fields
      show
      fill(Fixture::Exhibitions::NAME_FIELD, Fixture::Exhibitions::NAME)
    end

    def fill_exhibition_mandatory_data
      show
      fill(Fixture::Exhibitions::NAME_FIELD, Fixture::Exhibitions::NAME)
      select_museum(Fixture::Museum::FIRST_MUSEUM)
    end

    def fill_exhibition_translations
      active_language('catala')
      fill(Fixture::Exhibitions::ES_NAME_FIELD, Fixture::Exhibitions::ES_NAME)
      fill(Fixture::Exhibitions::CAT_NAME_FIELD, Fixture::Exhibitions::CAT_NAME)
      fill(Fixture::Exhibitions::CAT_SHORT_DESCRIPTION_FIELD, Fixture::Exhibitions::CAT_SHORT_DESCRIPTION)
      fill(Fixture::Exhibitions::CAT_DESCRIPTION_FIELD, Fixture::Exhibitions::CAT_DESCRIPTION)
    end

    def update_translations
      active_language('catala')
      fill(Fixture::Exhibitions::CAT_NAME_FIELD, Fixture::Exhibitions::CAT_OTHER_NAME)
      fill(Fixture::Exhibitions::CAT_SHORT_DESCRIPTION_FIELD, Fixture::Exhibitions::CAT_OTHER_SHORT_DESCRIPTION)
      fill(Fixture::Exhibitions::CAT_DESCRIPTION_FIELD, Fixture::Exhibitions::CAT_OTHER_DESCRIPTION)
    end

    def fill_media
      fill('image', Fixture::Exhibitions::LINK)
    end

    def click_add_exhibition
      has_css?('.add-exhibition-button', wait: 4)
      first('.add-exhibition-button', wait: 4).click
    end

    def create_one
      fill_exhibition_mandatory_data
      fill_media
      save
      self
    end

    def edit_exhibition
      click_edit
      fill(Fixture::Exhibitions::NAME_FIELD, Fixture::Exhibitions::OTHER_NAME)
    end

    def form_submit_deactivated?
      button = find('.submit')
      button.disabled?
    end

    def show
      has_css?('#action', wait: 2)
      find('#action').click
    end

    def be_checked?( element )
      find('input.show[type=checkbox]').selected?
    end

    def content?(content)
      has_content?(content, wait: 1)
    end

    def last_toggle_list
      has_css?('.toggle-exhibition-list', wait: 4, visible: false)
      all('.toggle-exhibition-list', wait: 4).last.click
    end

    def has_toggle?
      has_css?('.toggle-exhibition-list', wait: 5, visible: false)
    end

    def has_language_toggle_button?(language)
      has_css?(".toggle-language-#{language}", wait: 5)
    end

    def exhibition_name(exhibition)
      find('.exhibition-name', wait: 2, text: exhibition).text
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

    def click_delete
      has_css?('.delete-button',  exact_text: 'Delete', wait: 4)
      find('.delete-button').click
    end

    def delete_exhibition(exhibition)
      go_to_exhibition_info(exhibition)
      click_delete
      accept_alert
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
      has_css?('.exhibition-room .plus-button', wait: 4, exact_text: '+', visible: false)
    end

    def subscene_has_plus_button?
      has_css?('.exhibition-scene .exhibition-scene .plus-button', wait: 4)
    end

    def form_submit_deactivated?
      has_css?('.submit[disabled].cuac-exhibition-form')
    end

    def second_exhibition_shown?
      has_css?('.exhibition-name', exact_text: Fixture::Exhibitions::SECOND_EXHIBITION, wait: 2)
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

    def accept_alert
      has_css?('.accept-alert', wait: 4)
      find('.accept-alert').click
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

    def select_museum(name)
      first('#museums').click
      first('#museums option', text: name).click
    end

    def active_language(element)
      execute_script("document.getElementsByClassName('"+element+"')[0].click()")
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
