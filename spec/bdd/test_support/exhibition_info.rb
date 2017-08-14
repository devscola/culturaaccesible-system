module Page
  class ExhibitionInfo
    include Capybara::DSL

    def initialize
      validate!
    end

    def content?(name)
      has_content?(name)
    end

    def click_edit
      has_css?('.edit-button',  exact_text: 'Edit', wait: 4)
      find('.edit-button').click
    end

    def fill(field, content)
      fill_in(field, with: content, wait: 2)
    end

    def first_exhibition_name
      has_css?('.list-item', wait: 4)
      first('.exhibition-name').text
    end

    def save
      has_css?('.submit.cuac-exhibition-form', wait: 4)
      find('.submit.cuac-exhibition-form').click
    end

    private

    def validate!
      assert_selector('#info')
    end
  end
end
