module Page
  class Location
    include Capybara::DSL

    def initialize
      url = '/location'
      visit(url)
      validate!
    end

    def fill_form(location)
      location.each do |field, content|
        fill_in(field, with: content)
      end
    end

    def save
      find('.submit').click
    end

    def has_info?(content)
      has_content?(content)
    end

    private

    def validate!
      assert_selector('#formulary')
    end
  end
end
