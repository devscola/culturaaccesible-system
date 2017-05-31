module Page
  class Schedule
    include Capybara::DSL

    def initialize
      url = '/schedule'
      visit(url)
      validate!
    end

    def is_instanciated?
      has_css?('#formulary')
    end

    def fill_input(hours)
      fill_in('openingHours', with: hours)
    end

    def is_valid?
      !find('.add-button', visible: false).disabled?
    end

    def select_day
      all('.day-checkbox').first.set(true)
    end

    def select_all_days
      find('.all-day-checkbox').set(true)
    end

    def all_days_selected?
      all = all('.day-checkbox')
      checked = all.select {|checkbox| checkbox.value == true }
      return all.length == checked.length
    end

    def click_add_hour
      find('.add-button').click
    end

    def view_visible?(content)
      has_content?(content)
    end
    
    private

    def validate!
      assert_selector('#formulary')
    end
  end
end
