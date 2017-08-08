module Page
  class SceneInfo
    include Capybara::DSL

    def initialize
      validate!
    end

    def content?(name)
      has_content?(name)
    end

    def click_edit
      has_css?('.edit-button', wait: 2, exact_text: 'Edit')
      find('.edit-button').click
    end

    private

    def validate!
      assert_selector('#sceneInfo')
    end
  end
end
