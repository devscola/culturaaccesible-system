module Page
  class RoomInfo
    include Capybara::DSL

    def initialize
      url = '/room-info'
      visit(url)
      validate!
    end

    def content?(name)
      has_content?(name)
    end

    def find_content(selector)
      all(selector).last.text
    end

    def toggle_list
      has_css?('.toggle-exhibition-list', wait: 10, visible: true)
      first('.toggle-exhibition-list', wait: 4, visible: true).click
    end

    def go_to_room_info
      has_css?('.room-name', wait: 10)
      first('.room-name', wait: 4, visible: true).click
    end

    def go_to_last_room_info
      all('.room-name', wait: 4, visible: true).last.click
    end

    def go_to_second_room
      all('.room-name', wait: 4, visible: true)[1].click
    end

    def room_has_children?
      has_css?('.exhibition-room .exhibition-scene', wait: 2)
    end

    def fill(field, content)
      fill_in(field, with: content, wait: 2)
    end

    def submit
      find('.submit').click
    end

    def click_item_plus_button
      if(!has_css?('.exhibition-scene .plus-button', wait: 4, exact_text: '+').nil?)
        first('.exhibition-scene .plus-button', wait: 4, exact_text: '+').click
      end
    end
    
    def room_check_disabled?
      has_css?('.room', wait: 4, exact_text: 'room')
      input_disabled?('room')
    end

    def input_disabled?(field)
      has_css?("input[name=#{field}]:disabled")
    end

    def click_edit
      has_css?('.edit-button', wait: 5, exact_text: 'Edit', visible: true)
      find('.edit-button', wait: 5, exact_text: 'Edit', visible: true).click
    end

    def fill_form_with_languages
      fill('name', 'some room name')
      fill('language-name-es', 'nombre de room')
      fill('description-es', 'descripcion de room')
      fill('video-es', 'https://s3.amazonaws.com/pruebas-cova/more3minutes.mp4')
      fill('language-name-cat', 'nom de room')
      fill('description-cat', 'descripció de room')
      fill('video-cat', 'https://s3.amazonaws.com/pruebas-cova/more3minutes.mp4')
    end

    private

    def validate!
      assert_selector('#roomInfo')
    end
  end
end
