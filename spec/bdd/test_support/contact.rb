module Page
  class Contact
    include Capybara::DSL

    def initialize
      url = '/contact'
      visit(url)
      validate!
    end

    def save

    end

    def has_info?(phone)
      has_content?(phone)
    end

    def has_save_button?
      has_css?('#save')
    end

    def has_fields?
      has_css?('.field')
    end

    private

    def validate!
      page.assert_selector('#contact-view')
    end
  end
end
