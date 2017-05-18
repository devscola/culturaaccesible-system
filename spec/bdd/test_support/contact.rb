module Page
  class Contact
    include Capybara::DSL

    def initialize
      url = '/contact.html'
      visit(url)
      validate!
    end

    def save

    end

    def has_info?(phone)
      has_content?(phone)
    end

    private

    def validate!
      page.assert_selector('#contact-view')
    end
  end
end
