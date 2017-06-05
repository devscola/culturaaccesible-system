require 'spec_helper_bdd'
require_relative 'test_support/schedule'
require_relative '../../app'

feature 'Schedule form' do
  let(:current) { Page::Schedule.new }

  scenario 'validates hours and minutes format' do
    current.check('MON')

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
    expect(current.button_enabled?('.add-button')).to be false

    current.introduce_hours('08:00-14:00')
    current.check('MON')

    expect(current.button_enabled?('.add-button')).to be true
  end

  scenario 'disallows adding hours after uncheck days' do 
    current.check('MON')
    current.introduce_hours('08:00-14:00')
    current.check('MON')

    expect(current.button_enabled?('.add-button')).to be false
  end
  
  scenario 'selects all days at once' do
    current.check('select-all')
    expect(current.all_fields_checked?).to be true
  end

  scenario 'resets checked fields when adding another hour' do
    current.check('MON')
    current.introduce_hours('08:00-14:00')
    current.click_add_hour

    current.check('SUN')
    current.introduce_hours('16:00-20:00')
    current.click_add_hour

    expect(current.day_unchecked?('SUN')).to be true
    expect(current.hour_field_empty?).to be true
  end

  scenario 'shows introduced information' do
    current.check('MON')
    current.introduce_hours('08:00-14:00')
    current.click_add_hour
    current.check('MON')
    current.introduce_hours('16:00-20:00')
    current.click_add_hour

    expect(current.has_content?('08:00-14:00')).to be true
    expect(current.has_content?('16:00-20:00')).to be true
    
  end

end
