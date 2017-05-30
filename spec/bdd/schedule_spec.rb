require 'spec_helper_bdd'
require_relative 'test_support/schedule'
require_relative '../../app'

feature 'Schedule form' do
  scenario 'is instanciated' do
    current = Page::Schedule.new
    expect(current.is_instanciated?).to be true
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
  scenario 'must have almost one day clicked' do
    current = Page::Schedule.new
    expect(current.is_valid?).to eq false
    current.select_day
    current.fill_input('08:00/14:00')
    expect(current.is_valid?).to eq true
  end

  xscenario 'when select all day is clicked all days are selected' do
    current = Page::Schedule.new
    current.select_all_days
    expect(current.all_days_selected?).to eq true
  end
end
