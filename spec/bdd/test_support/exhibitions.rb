module Page
  class Exhibitions
    include Capybara::DSL
    def initialize
      url = '/exhibitions'
      visit(url)
      validate!
    end

    def exhibition_list?
      has_css?('.exhibition')
    end

    def validate!
      page.assert_selector('#exhibitions-list', visible: false)
    end
  end
end
