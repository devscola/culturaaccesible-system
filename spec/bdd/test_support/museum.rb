module Page
  class Museum
    include Capybara::DSL

    WEEK = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']

    def initialize
      url = '/museum'
      visit(url)
      validate!
    end

    def click_new_museum
      find('#newMuseum.cuac-new-button').click
    end

    def has_form?
      has_css?('#formulary')
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

    def submit
      find('#action').click
    end

    def click_edit_button
      find('.edit-button').click
    end

    def has_info?(content)
      has_content?(content)
    end

    def has_edit_button?
      has_css?('.edit-button')
    end

    def shows_info?
      has_css?('.view')
    end

    def add_input(type)
      find(type).click
    end

    def button_enabled?(css_class)
      button = find(css_class)
      result = button[:disabled]

      return true if result.nil?

      false
    end

    def has_extra_input?(actual_inputs = 1)
      inputs = all("input[name^='phone']")
      inputs.size > actual_inputs
    end

    def remove_field_content
      fill_in('link', with: '')
    end

    def introduce_hours(range)
      fill_in('openingHours', with: range)
    end

    def click_checkbox(day)
      find_field(name: day).click
    end

    def editable_name
      find('[name=name]').value
    end

    def has_field?(name)
      find("[name=#{name}]").value
    end

    def all_fields_checked?
      WEEK.each do |day|
        if day_unchecked?(day)
          return false
        end
      end
      true
    end

    def day_unchecked?(day)
      !has_checked_field?(day)
    end

    def click_add_hour
      find('.add-button.cuac-schedule-hours').click
    end

    def hours_field_empty?
      hours_field = find('[name=openingHours]').value
      hours_field.length == 0
    end

    def focus_in_input?(name)
      focus = evaluate_script('document.activeElement.name')
      name == focus
    end

    private

    def validate!
      assert_selector('#newMuseum.cuac-new-button')
      assert_selector('#formulary', visible: false)
      assert_selector('#result', visible: false)
    end
  end
end
