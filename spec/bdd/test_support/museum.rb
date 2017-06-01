module Page
  class Museum
    include Capybara::DSL

    def initialize
      url = '/museum'
      visit(url)
      validate!
    end

    def fill_input(field, content)
      fill_in(field, with: content)
    end

    def save_enabled?
      button = find('#action')
      result = button[:disabled]

      return true if result.nil?

      false
    end

    def remove_field_content
      fill_in('link', with: '')
    end

    private

    def validate!
      assert_selector('#formulary')
    end
  end
end
