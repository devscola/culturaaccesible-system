module Page
  class Item
    include Capybara::DSL

    def initialize
      validate!
    end

    def fill(name, content)
      fill_in(name, with: content)
    end

    def content?(content)
      has_content?(content)
    end

    def input_value?(field)
      find("[name=#{field}]").value
    end

    def submit
      find('.submit').click
    end

    def has_edit_button?
      has_css?('.edit-button')
    end

    def click_edit
      find('.edit-button', wait: 4).click
    end

    def form_visible?
      form = find('.form', visible: false)
      form.visible?
    end

    def other_name?
      has_content?('La costellazione')
    end

    def type_max_four_characters
      date_length = find('[name=date]').value.length
      (date_length <= 4)
    end

    def check_room
      find_field(name: 'room').click
    end

    def room_checked?
      has_checked_field?(name: 'room')
    end

    def room_check_disabled?
      input_disabled?('room')
    end

    def accept_alert
      find('.accept-alert').click
    end

    def cancel_alert
      find('.cancel-alert').click
    end

    def alert_displayed?
      has_css?('.room-alert')
    end

    def input_disabled?(field)
      has_css?("input[name=#{field}]:disabled")
    end

    def submit_disabled?
      has_css?('.submit:disabled')
    end

    def input_blank?(field)
      find("input[name=#{field}]", visible: false ).value.length < 1
    end

    def add_room
      fill('name', 'some room name')
      check_room
      submit
    end

    def add_item
      fill('name', 'some item name')
      fill('author', 'some author')
      submit
    end

    def find_suggested_number
      find('[name=number]').value
    end

    private

    def validate!
      assert_selector('#formulary')
      assert_selector("input[name='name']", visible: false)
    end
  end
end
