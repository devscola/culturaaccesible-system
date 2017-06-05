module Page
  class Schedule
    include Capybara::DSL

    WEEK = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']

    def initialize
      url = '/schedule'
      visit(url)
      validate!
    end

    def introduce_hours(range)
      fill_in('openingHours', with: range)
    end

    def check(day)
      find_field(name: day).click
    end

    def any_day_checked?
      has_checked_field?('days') 
    end

    def day_unchecked?(day)
      !has_checked_field?(day)
    end

    def all_fields_checked?
      WEEK.each do |day| 
        if day_unchecked?(day)
          return false
        end
      end
      true
    end

    def hour_field_empty?
      hour_field = find('.form-control').value
      return hour_field.length == 0
    end

    def click_add_hour
      find('.add-button').click
    end

    def button_enabled?(css_class)
      button = find(css_class)
      result = button[:disabled]

      return true if result.nil?

      false
    end

    private

    def validate!
      assert_selector('#formulary')
    end
  end
end
