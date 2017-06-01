require 'spec_helper_bdd'
require_relative 'test_support/fixture_museum'
require_relative 'test_support/museum'

feature 'Museum' do
  scenario 'allows submit when enough content' do
    current = Fixture::Museum.enough_content
    expect(current.save_enabled?).to be true
  end

  xscenario 'disallows submit after enough content removed', :wip do
    current = Fixture::Museum.enough_content
    current.remove_field_content

    expect(current.save_enabled?).to be false
  end
end
