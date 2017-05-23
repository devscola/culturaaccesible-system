require_relative 'exhibitions'

class Fixture
  extend Capybara::DSL

  NAME_FIELD = 'name'
  LOCATION_FIELD = 'location'
  NAME = 'some name'
  LOCATION = 'some location'

  def self.show_exhibition_form
    current = Page::Exhibitions.new
    current.show
    current
  end

  def self.fill_form
    current = Page::Exhibitions.new
    current.show

    current.fill(NAME_FIELD, NAME,)
    current.fill(LOCATION_FIELD, LOCATION)

    current
  end

  def self.save_exhibition
    current = self.fill_form
    current.save
    current
  end

end
