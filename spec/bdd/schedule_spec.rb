require 'spec_helper_bdd'
require_relative 'test_support/schedule'
require_relative '../../app'

feature 'Schedule form' do
  scenario 'is instanciated' do
    current = Page::Schedule.new
    expect(current.is_instanciated?).to be true
  end

  scenario 'shows schedule view after add some hours on some days' do
    current = Page::Schedule.new
    current.select_day
    current.fill_input('08:00/14:00')
    current.click_add_hour
    expect(current.view_visible?('08:00/14:00')).to eq true
  end
end

feature 'Schedule form hours input' do
  scenario 'validates hours and minutes format' do
    current = Page::Schedule.new
    current.select_day
    current.fill_input('23:00/24:00')
    expect(current.is_valid?).to eq false
    current.fill_input('08:60/14:00')
    expect(current.is_valid?).to eq false
    current.fill_input('8:00/14:00')
    expect(current.is_valid?).to eq false
  end

  scenario 'validates from hours is bigger than to hours' do
    current = Page::Schedule.new
    current.select_day
    current.fill_input('09:00/08:00')
    expect(current.is_valid?).to eq false
  end

end

feature 'Schedule days' do
  scenario 'must have almost one day clicked before type an hour' do
    current = Page::Schedule.new
    current.select_day
    current.fill_input('08:00/14:00')
    expect(current.is_valid?).to eq true
  end

  scenario 'needs some day clicked' do
    current = Page::Schedule.new
    current.fill_input('08:00/14:00')
    expect(current.is_valid?).to eq false
  end

  scenario 'needs some hours formatted' do
    current = Page::Schedule.new
    current.select_day
    expect(current.is_valid?).to eq false
  end

  scenario 'allows add with a select day after type an hour' do
    current = Page::Schedule.new
    current.fill_input('08:00/14:00')
    expect(current.is_valid?).to eq false
    current.select_day
    expect(current.is_valid?).to eq true
  end

  scenario 'when select all day is clicked all days are selected' do
    current = Page::Schedule.new
    current.select_all_days
    expect(current.all_days_selected?).to eq true
  end
end
