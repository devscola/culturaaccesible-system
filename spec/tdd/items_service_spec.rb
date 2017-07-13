require 'spec_helper_tdd'
require_relative '../../system/items/service'
require_relative '../../system/exhibitions/service'

describe Items::Service do
  before(:each) do
    Items::Repository.flush
		exhibition = add_exhibition
  end

	let(:exhibition) { add_exhibition }

  it 'retrieve an scene by id' do
		name = 'Item'
		number = '1.2'
		result = add_scene(name, number, exhibition[:id], exhibition[:id])
		item = Items::Service.retrieve(result[:id])

		expect(item[:name]).to eq name
  end

  it 'retrieve all item children by parent id' do
    item_name = 'Item'
    item_number = '1.2'
    sub_item_name = 'Sub Item'
    sub_item_number = '1.2.2'

    item = add_scene(item_name, item_number, exhibition[:id], exhibition[:id])
    sub_item = add_scene(sub_item_name, sub_item_number, item[:id], exhibition[:id])
    children = Items::Service.retrieve_by_parent(item[:id])

    expect(children.first[:name]).to eq sub_item_name
  end

	def add_scene(name, number, parent_id, exhibition_id)
    scene = { 'id'=> '', 'name' => name, 'number' => number, 'parent_id' => parent_id, 'exhibition_id' => exhibition_id }
    Items::Service.store_scene(scene)
  end

	def add_exhibition
    exhibition = { 'name' => 'name', 'location' => 'location' }
    Exhibitions::Service.store(exhibition)
  end
end
