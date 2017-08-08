module Page
  class RoomInfo
    include Capybara::DSL

    def initialize
      validate!
    end

    def content?(name)
      has_content?(name)
    end

    def click_edit
      find('.edit-button', wait: 2, exact_text: 'Edit').click
    end

    private

    def validate!
      assert_selector('#roomInfo')
    end
  end
end
