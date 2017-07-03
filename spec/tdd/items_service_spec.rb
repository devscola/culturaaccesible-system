require 'spec_helper_tdd'
require_relative '../../system/items/service'
require_relative '../../system/exhibitions/service'

describe Items::Service do
  before(:each) do
    Items::Repository.flush
		exhibition = add_exhibition
  end

	let(:exhibition) { add_exhibition }

  it 'retrive an item by id' do
		name = 'Item'
		number = '1.2'
		result = add_item(name, number, exhibition[:id])
		item = Items::Service.retrieve(result[:id])

		expect(item[:name]).to eq name
  end

	def add_item(name, number, exhibition_id)
    item = { 'name' => name, 'number' => number, 'exhibition_id' => exhibition_id }
    Items::Service.store(item)
  end

	def add_exhibition
    exhibition = { 'name' => 'name', 'location' => 'location' }
    Exhibitions::Service.store(exhibition)
  end
end