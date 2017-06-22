require 'spec_helper_bdd'
require_relative 'test_support/fixture_museum'
require_relative 'test_support/museum'

feature 'Museum' do
  scenario 'enables create new museum when triggered' do
    current = Fixture::Museum.initial_state
    current.click_new_museum
    expect(current.has_form?).to be true
  end

  scenario 'allows submit when enough content' do
    current = Fixture::Museum.enough_content
    expect(current.save_enabled?).to be true
  end

  scenario 'shows info when submitted' do
    current = Fixture::Museum.enough_content
    current.submit
    expect(current.shows_info?).to be true
  end

  context 'contact section' do
    scenario 'disallows add input without content' do
      current = Fixture::Museum.showing_form
      expect(current.button_enabled?('.phone')).to be false
    end

    scenario 'disallows add input after removing content' do
      current = Fixture::Museum.showing_form

      current.fill_input('phone1', '0')
      current.find_field('phone1').send_keys(:backspace)

      expect(current.button_enabled?('.phone')).to be false
    end

    scenario 'enables add input with content' do
      current = Fixture::Museum.showing_form
      current.fill_input('phone1', 'some phone')

      expect(current.button_enabled?('.phone')).to be true
    end

    scenario 'adds another input of the same type' do
      current = Fixture::Museum.showing_form
      current.fill_input('phone1', 'some phone')

      current.add_input('.phone')

      expect(current.has_extra_input?).to be true
    end

    scenario 'allows adding depending on last input' do
      current = Fixture::Museum.contact_section_with_an_extra_input
      current.fill_input('phone1', '')
      current.fill_input('phone1', 'some phone')

      expect(current.button_enabled?('.phone')).to be false
    end

    scenario 'moves focus to next input after adding' do
      current = Fixture::Museum.contact_section_with_an_extra_input
      expect(current.focus_in_input?('phone2')).to be true
    end
  end

  context 'schedule section' do
    scenario 'validates hours and minutes format' do
      current = Fixture::Museum.showing_form
      current.click_checkbox('MON')

      hours_out_of_range = '23:00-24:00'
      current.introduce_hours(hours_out_of_range)
      expect(current.button_enabled?('.add-button')).to be false

      minutes_out_of_range = '08:60-14:00'
      current.introduce_hours(minutes_out_of_range)
      expect(current.button_enabled?('.add-button')).to be false

      hours_with_one_digit = '8:00-14:00'
      current.introduce_hours(hours_with_one_digit)
      expect(current.button_enabled?('.add-button')).to be false

      invalid_hours_range = '09:00-08:00'
      current.introduce_hours(invalid_hours_range)
      expect(current.button_enabled?('.add-button')).to be false
    end

    scenario 'allows add with appropiate inputs' do
      current = Fixture::Museum.showing_form
      expect(current.button_enabled?('.add-button')).to be false

      current.introduce_hours('08:00-14:00')
      current.click_checkbox('MON')

      expect(current.button_enabled?('.add-button')).to be true
    end

    scenario 'disallows adding hours after uncheck days' do
      current = Fixture::Museum.showing_form
      current.click_checkbox('MON')
      current.introduce_hours('08:00-14:00')
      current.click_checkbox('MON')

      expect(current.button_enabled?('.add-button')).to be false
    end

    scenario 'allows to add the same hour to a diferent day' do
      current = Fixture::Museum.showing_form
      current.click_checkbox('MON')
      current.introduce_hours('08:00-14:00')
      current.click_add_hour
      current.click_checkbox('MON')
      current.click_checkbox('TUE')
      current.introduce_hours('08:00-14:00')
      current.click_add_hour


      expect(current.has_content?('TUE 08:00-14:00')). to be true
      expect(current.has_content?('08:00-14:00', count: 3)). to be false
      expect(current.all_fields_checked?).to be false
    end

    scenario 'selects all days at once' do
      current = Fixture::Museum.showing_form
      current.click_checkbox('select-all')
      expect(current.all_fields_checked?).to be true
    end

    scenario 'empties form after adding' do
      current = Fixture::Museum.showing_form
      current.click_checkbox('MON')
      current.introduce_hours('08:00-14:00')
      current.click_add_hour

      expect(current.day_unchecked?('MON')).to be true
      expect(current.hours_field_empty?).to be true
    end

    scenario 'shows preview information' do
      current = Fixture::Museum.showing_form
      current.click_checkbox('MON')
      current.introduce_hours('08:00-14:00')
      current.click_add_hour
      current.click_checkbox('MON')
      current.introduce_hours('16:00-20:00')
      current.click_add_hour

      expect(current.has_content?('08:00-14:00')).to be true
      expect(current.has_content?('16:00-20:00')).to be true
    end

  end

  context 'view' do
    scenario 'shows edited input value' do
      current = Fixture::Museum.contact_section_with_an_extra_input

      current.fill_input('phone2', 'some other phone')
      current.fill_input('phone1', 'some edited phone')
      current.submit

      expect(current.has_info?('some edited phone')).to be true
    end
  end

  context 'edit' do
    scenario 'shows fields when editing' do
      current = Fixture::Museum.submitted

      current.click_edit_button

      expect(current.editable_name).to eq Fixture::Museum.data['name']
      expect(current.has_field?('phone1')).to eq Fixture::Museum.phone
    end

    scenario 'editable hour with bad format disable save button' do
      new_hour = '21:00-25:00'
      current = Fixture::Museum.submitted

      current.click_edit_button
      current.edit_hour(new_hour)
      current.lose_focus

      expect(current.edited_hour).to eq new_hour
      expect(current.save_disabled?).to be true
    end

    scenario 'save edited hour' do
      new_hour = '10:00-20:00'
      old_hour = '08:00-14:00'
      current = Fixture::Museum.submitted

      current.click_edit_button
      current.edit_hour(new_hour)
      current.submit

      expect(current.has_content?(new_hour)).to be true
      expect(current.has_content?(old_hour)).to be false
    end
  end
end
