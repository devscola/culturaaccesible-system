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

    private

    def validate!
      assert_selector('#formulary', visible: false)
    end
  end
end
