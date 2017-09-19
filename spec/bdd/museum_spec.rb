require 'spec_helper_bdd'
require_relative 'test_support/museum'
require_relative 'test_support/fixture_museum'

feature 'Museum' do
  before(:all) do
    Fixture::Museum.pristine
  end

  context 'created' do
    before(:all) do
      Fixture::Museum.pristine.complete_scenario
    end

    let(:current) { Page::Museum.new }

    scenario 'allows submit when enough content' do
      current.click_new_museum
      current.fill_with_extra_content
      
      expect(current.save_enabled?).to be true
    end

    scenario 'shows info when submitted' do
      current.go_to_museum_info(Fixture::Museum::FIRST_MUSEUM)

      expect(current.shows_info?).to be true
      expect(current.has_content?(Fixture::Museum::MANDATORY_DATA['name'])).to be true
    end

    context 'location section' do
      scenario 'validates that google maps link has coordinates' do
        current.click_new_museum
        current.fill_with_bad_link
        current.change_focus

        expect(current.has_css?('.has-error')).to be true
      end
    end

    context 'contact section' do
      scenario 'disallows add input without content' do
        current.click_new_museum

        expect(current.button_enabled?('.phone')).to be false
      end

      scenario 'disallows add input after removing content' do
        current.click_new_museum

        current.fill_input('phone1', '0')
        current.find_field('phone1').send_keys(:backspace)

        expect(current.button_enabled?('.phone')).to be false
      end

      scenario 'enables add input with content' do
        current.click_new_museum
        current.fill_input('phone1', Fixture::Museum::PHONE)

        expect(current.button_enabled?('.phone')).to be true
      end

      scenario 'adds another input of the same type' do
        current.click_new_museum
        current.fill_input('phone1', Fixture::Museum::PHONE)
        current.add_input('.phone')

        expect(current.has_extra_input?).to be true
      end

      scenario 'allows adding depending on last input' do
        current.click_new_museum
        current.contact_section_with_an_extra_input
        current.fill_input(Fixture::Museum::PHONE_FIELD, Fixture::Museum::PHONE)
        current.fill_input(Fixture::Museum::PHONE_FIELD, Fixture::Museum::PHONE)

        expect(current.button_enabled?('.phone')).to be false
      end

      scenario 'moves focus to next input after adding' do
        current.click_new_museum
        current.contact_section_with_an_extra_input

        expect(current.focus_in_input?('phone2')).to be true
      end

      scenario 'allows adding with only one character' do
        current.click_new_museum

        current.fill_input('phone1', '0')
        current.add_input('.phone')
        current.fill_input('phone2', '0')

        expect(current.button_enabled?('.phone')).to be true
      end
    end

    context 'schedule section' do
      scenario 'validates hours and minutes format' do
        current.click_new_museum
        current.click_checkbox(Fixture::Museum::MONDAY)

        current.introduce_hours(Fixture::Museum::HOUR_OUT_OF_RANGE)
        expect(current.button_enabled?('.add-button')).to be false

        current.introduce_hours(Fixture::Museum::MINUTES_OUT_OF_RANGE)
        expect(current.button_enabled?('.add-button')).to be false

        current.introduce_hours(Fixture::Museum::HOUR_WITH_ONE_DIGIT)
        expect(current.button_enabled?('.add-button')).to be false

        current.introduce_hours(Fixture::Museum::INVALID_HOUR_RANGE)
        expect(current.button_enabled?('.add-button')).to be false
      end

      scenario 'allows add with appropiate inputs' do
        current.click_new_museum
        expect(current.button_enabled?('.add-button')).to be false

        current.introduce_hours(Fixture::Museum::HOUR)
        current.click_checkbox(Fixture::Museum::MONDAY)

        expect(current.button_enabled?('.add-button')).to be true
      end

      scenario 'disallows adding hours after uncheck days' do
        current.click_new_museum
        current.click_checkbox(Fixture::Museum::MONDAY)
        current.introduce_hours(Fixture::Museum::HOUR)
        current.click_checkbox(Fixture::Museum::MONDAY)

        expect(current.button_enabled?('.add-button')).to be false
      end

      scenario 'disallows to add the same hour to the same day' do
        current.click_new_museum
        current.click_checkbox(Fixture::Museum::MONDAY)
        current.introduce_hours(Fixture::Museum::HOUR)
        current.click_add_hour
        current.click_checkbox(Fixture::Museum::MONDAY)
        current.introduce_hours(Fixture::Museum::HOUR)
        current.click_add_hour

        expect(current.has_content?(Fixture::Museum::NOT_DUPLICATED_SCHEDULE_HOUR)).to be true
        expect(current.has_content?(Fixture::Museum::DUPLICATED_SCHEDULE_HOUR)).to be false
      end

      scenario 'selects all days at once' do
        current.click_new_museum

        current.click_checkbox('select-all')

        expect(current.all_fields_checked?).to be true
      end

      scenario 'empties form after adding' do
        current.click_new_museum

        current.click_checkbox(Fixture::Museum::MONDAY)
        current.introduce_hours(Fixture::Museum::HOUR)
        current.click_add_hour

        expect(current.day_unchecked?(Fixture::Museum::MONDAY)).to be true
        expect(current.hours_field_empty?).to be true
      end

      scenario 'shows preview information' do
        current.click_new_museum

        current.click_checkbox(Fixture::Museum::MONDAY)
        current.introduce_hours(Fixture::Museum::HOUR)
        current.click_add_hour
        current.click_checkbox(Fixture::Museum::MONDAY)
        current.introduce_hours(Fixture::Museum::ALTERNATIVE_HOUR)
        current.click_add_hour

        expect(current.has_content?(Fixture::Museum::HOUR)).to be true
        expect(current.has_content?(Fixture::Museum::ALTERNATIVE_HOUR)).to be true
      end
    end

    context 'view' do
      scenario 'shows edited input value' do
        current.click_new_museum
        current.contact_section_with_an_extra_input

        current.fill_input('phone2', Fixture::Museum::PHONE)
        current.fill_input('phone1', Fixture::Museum::EXTRA_PHONE)
        current.submit

        expect(current.has_info?(Fixture::Museum::EXTRA_PHONE)).to be true
      end
    end

    context 'edit' do
      before(:all) do
        Fixture::Museum.pristine.complete_scenario
      end

      let(:current) { Page::Museum.new }

      scenario 'shows fields when editing' do
        current.go_to_museum_info(Fixture::Museum::FIRST_MUSEUM)
        current.click_edit_button
        current.fill_with_extra_content

        expect(current.editable_name).to eq Fixture::Museum::MANDATORY_DATA['name']
        expect(current.has_field?('phone1')).to eq Fixture::Museum::PHONE
      end

      scenario 'editable hour with bad format disable save button' do
        current.go_to_museum_info(Fixture::Museum::FIRST_MUSEUM)
        current.click_edit_button
        current.fill_with_extra_content
        current.edit_hour(Fixture::Museum::HOUR_OUT_OF_RANGE)
        current.lose_focus

        expect(current.edited_hour).to eq Fixture::Museum::HOUR_OUT_OF_RANGE
        expect(current.save_disabled?).to be true
      end

      scenario 'save edited hour' do
        current.go_to_museum_info(Fixture::Museum::FIRST_MUSEUM)
        current.click_edit_button
        current.fill_with_extra_content
        current.edit_hour(Fixture::Museum::ALTERNATIVE_HOUR)
        current.submit

        expect(current.has_content?(Fixture::Museum::ALTERNATIVE_HOUR)).to be true
        expect(current.has_content?(Fixture::Museum::HOUR)).to be false
      end

      scenario 'edit museums from museum info' do
        current.go_to_museum_info(Fixture::Museum::FIRST_MUSEUM)
        current.click_edit_button
        current.fill_with_extra_content
        current.submit
        current.go_to_museum_info(Fixture::Museum::FIRST_MUSEUM)
        current.click_edit_button

        expect(current.has_field_value?(Fixture::Museum::NAME_FIELD, Fixture::Museum::FIRST_MUSEUM)).to be true
        expect(current.has_field_value?(Fixture::Museum::STREET_FIELD, Fixture::Museum::FIRST_STREET)).to be true
        expect(current.has_field_value?(Fixture::Museum::PHONE_FIELD, Fixture::Museum::PHONE)).to be true
        expect(current.has_field_value?(Fixture::Museum::PRICE_FIELD, Fixture::Museum::PRICE)).to be true
        expect(current.has_field_value?(Fixture::Museum::MAP_LINK_FIELD, Fixture::Museum::MAP_LINK)).to be true
        expect(current.has_content?(Fixture::Museum::HOUR)).to be true
      end

      scenario 'update edited phone and price deleted' do
        Fixture::Museum.pristine.complete_scenario
        current = Page::Museum.new
        current.go_to_museum_info(Fixture::Museum::FIRST_MUSEUM)
        current.click_edit_button
        current.add_content_with_extra_phones_and_prices
        current.remove_added_input('phone1')
        current.remove_added_input('general1')
        current.submit

        expect(current.has_content?(Fixture::Museum::PHONE)).to be false
        expect(current.has_content?(Fixture::Museum::PRICE)).to be false
      end
    end
  end
end
