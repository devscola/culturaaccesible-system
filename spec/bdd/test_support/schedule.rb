module Page
  class Schedule
    include Capybara::DSL

    def initialize
      url = '/schedule'
      visit(url)
      validate!
    end

    def is_instanciated?
      has_css?('#formulary', visible: false)
    end

    def fill_input(hours)
      fill_in('openingHours', with: hours)
    end

    def is_valid?
      !find('.add-button').disabled?
    end

    def select_day
      all('.day-checkbox', visible: false).first.set(true)
    end

    def select_all_days
      find('.all-day-checkbox', visible: false).set(true)
    end

    def all_days_selected?
      all = all('.day-checkbox', visible: false)
      checked = all.select {|checkbox| checkbox.value == true }
      return all.length == checked.length
    end

    private

    def validate!
      assert_selector('#formulary', visible: false)
    end
  end
end
