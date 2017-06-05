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

    def select_first_day
      all('.day-checkbox').first.set(true)
    end

    def select_last_day
      all('.day-checkbox').last.set(true)
    end

    def days_checked?
      has_checked_field?('days') 
    end

    def select_all_days
      find('.all-day-checkbox').set(true)
    end

    def hour_field_empty?
      hour_field = find('.form-control').value
      return hour_field.length == 0
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
