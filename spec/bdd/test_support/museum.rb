require_relative 'fixture_museum'

module Page
  class Museum
    include Capybara::DSL

    def initialize
      url = '/museum'
      visit(url)
      validate!
    end

    def fill_mandatory_content
      Fixture::Museum::MANDATORY_DATA.each do |field, content|
        fill_input(field, content)
      end
    end

    def fill_with_extra_content
      fill_mandatory_content
      fill_input(Fixture::Museum::PHONE_FIELD, Fixture::Museum::PHONE)
      fill_input(Fixture::Museum::PRICE_FIELD, Fixture::Museum::PRICE)
      fill_input(Fixture::Museum::MAP_LINK_FIELD, Fixture::Museum::MAP_LINK)
      click_checkbox(Fixture::Museum::MONDAY)
      introduce_hours(Fixture::Museum::HOUR)
      click_add_hour
    end

    def fill_input(field, content)
      fill_in(field, with: content)
    end

    def click_new_museum
      first('#newMuseum').click
    end

    def click_checkbox(day)
      find_field(name: day).click
    end

    def introduce_hours(range)
      fill_in('openingHours', with: range)
    end

    def click_add_hour
      first('.add-button.cuac-schedule-hours').click
    end

    def submit
      first('#saveMuseum').click
    end

    def save_enabled?
      has_css?('.submit:enabled', exact_text: 'Save', wait: 4)
    end

    def go_to_museum_info(museum_name)
      has_css?('.museum-name', wait: 6, text: museum_name)
      first('.museum-name', text: museum_name, visible: true).click
    end

    def fill_with_bad_link
      bad_link = "https://www.google.es/maps/place/Museo+Guggenheim+Bilbao/"
      fill_in('link', with: bad_link)
    end

    def change_focus
      first('[name=region]').click
    end

    def button_enabled?(css_class)
      button = first(css_class)
      result = button[:disabled]

      return true if result.nil?

      false
    end

    def add_input(type)
      first(type).click
    end

    def has_extra_input?(actual_inputs = 1)
      inputs = all("input[name^='phone']")
      inputs.size > actual_inputs
    end

    def contact_section_with_an_extra_input
      fill_mandatory_content
      fill_input(Fixture::Museum::PHONE_FIELD, Fixture::Museum::PHONE)
      add_input('.phone')
    end

    def add_content_with_extra_phones_and_prices
      fill_mandatory_content
      fill_input('phone1', Fixture::Museum::PHONE)
      add_input('.phone')
      fill_input('phone2', Fixture::Museum::OTHER_PHONE)
      fill_input('general1', Fixture::Museum::PRICE)
      add_input('.general')
      fill_input('general2', Fixture::Museum::OTHER_PRICE)
    end

    def save_disabled?
      has_css?('.submit:disabled')
    end

    def click_edit_button
      has_css?('.edit-button', wait: 2)
      first('.edit-button').click
    end

    def has_field_value?(field, value)
      (find_field(field).value == value)
    end

    def shows_info?
      has_css?('.view')
    end

    def lose_focus
      submit
    end

    def editable_name
      first('[name=name]').value
    end

    def edit_hour(hour)
      element = first('.editable-hour')
      element.send_keys(:end)
      (0..hour.length).each do |i|
        element.send_keys(:backspace)
      end
      element.send_keys(hour)
    end

    def remove_added_input(name)
      element = first("[name=#{name}]")
      element.send_keys(:end)
      (0..element.value.length).each do |i|
        element.send_keys(:backspace)
      end
    end

    def edited_hour
      first('.editable-hour').text
    end

    def has_field?(name)
      first("[name=#{name}]").value
    end

    def all_fields_checked?
      Fixture::Museum::WEEK.each do |day|
        if day_unchecked?(day)
          return false
        end
      end
      true
    end

    def day_unchecked?(day)
      !has_checked_field?(day)
    end

    def hours_field_empty?
      hours_field = first('[name=openingHours]').value
      hours_field.length == 0
    end

    def focus_in_input?(name)
      focus = evaluate_script('document.activeElement.name')
      name == focus
    end

    def has_info?(content)
      has_content?(content)
    end







    # def initial_state
    #   Page::Museum.new
    # end

    # def showing_form
    #   current = initial_state
    #   current.click_new_museum
    #   current
    # end

    # def has_sidebar?
    #   has_css?('#listing')
    # end

    # def has_form?
    #   has_css?('#formulary')
    # end

    # def has_edit_button?
    #   has_css?('.edit-button')
    # end

    # def remove_field_content
    #   fill_in('link', with: '')
    # end

    # def fill_with_good_link
    #   good_link = "https://www.google.es/maps/place/Institut+Valenci%C3%A0+d'Art+Modern/@39.4723137,-0.3909856,15z"
    #   fill_in('link', with: good_link)
    # end

    private

    def validate!
      assert_selector('#formulary', visible: false)
      assert_selector('#result', visible: false)
      assert_selector("input[name='name']", visible: false)
      assert_selector("input[name='street']", visible: false)
      has_no_css?('.has-error')
    end
  end
end
