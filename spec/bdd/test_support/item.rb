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

    def submit
      find('[name=submit]').click
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

    def accept_alert
      find('.accept-alert').click
    end

    def cancel_alert
      find('.cancel-alert').click
    end

    def alert_displayed?
      has_css?('.room-alert')
    end

    def input_visible?(field)
      has_css?("input[name=#{field}]")
    end

    def input_blank?(field)
      find("input[name=#{field}]", visible: false ).value.length < 1
    end

    private

    def validate!
      assert_selector('#formulary')
      assert_selector("input[name='name']", visible: false)
    end
  end
end
