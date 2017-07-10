module Page
  class ExhibitionInfo
    include Capybara::DSL

    def initialize
      validate!
    end

    def content?(name)
      has_content?(name)
    end

    private

    def validate!
      assert_selector('#info')
    end
  end
end
