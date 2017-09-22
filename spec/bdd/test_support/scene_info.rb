module Page
  class SceneInfo
    include Capybara::DSL

    def initialize
      url = '/scene-info'
      visit(url)
      validate!
    end

    def content?(name)
      has_content?(name)
    end

    def click_edit
      has_css?('.edit-button', wait: 2, exact_text: 'Edit')
      find('.edit-button').click
    end

    def toggle_list
      has_css?('.toggle-exhibition-list', wait: 4, visible: true)
      first('.toggle-exhibition-list', wait: 10, visible: true).click
    end

    def last_toggle_list
      has_css?('.toggle-exhibition-list', wait: 10, visible: true)
      all('.toggle-exhibition-list', wait: 4, visible: true).last.click
    end

    def scene_in_room_has_children?
      has_css?('.exhibition-room .exhibition-scene .exhibition-scene', wait: 2)
    end

    def go_to_scene_info
      has_css?('.item-name', wait: 10)
      all('.item-name', wait: 4, visible: true).first.click
    end

    def go_to_subscene_info
      has_css?('.subscene-name', wait: 10)
      all('.subscene-name', wait: 4, visible: true).first.click
    end

    def room_check_disabled?
      has_css?('.room', wait: 4, exact_text: 'room')
      input_disabled?('room')
    end

    def input_disabled?(field)
      has_css?("input[name=#{field}]:disabled")
    end

    private

    def validate!
      assert_selector('#sceneInfo')
    end
  end
end
