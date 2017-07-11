module Page
  class SceneInfo
    include Capybara::DSL

    def initialize
      validate!
    end

    def content?(name)
      has_content?(name)
    end

    private

    def validate!
      assert_selector('#sceneInfo')
    end
  end
end
