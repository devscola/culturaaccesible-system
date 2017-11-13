require 'spec_helper_tdd'
require_relative '../../system/items/service'
require_relative '../../system/exhibitions/service'
require_relative '../../system/exhibitions/repository'

describe Items::Service do
  LOCALE = 'es'

  before(:each) do
    Items::Repository.flush
  end

	let(:exhibition) { add_exhibition }

  it 'retrieve an scene by id' do
		name = 'Item'
		number = '1-2'
		result = add_scene(name, number, exhibition[:id], exhibition[:id])
		item = Items::Service.retrieve(result[:id])

		expect(item[:name]).to eq name
  end

  it 'retrieve all item children by parent id' do
    item_name = 'Item'
    item_number = '1-2-0'
    sub_item_name = 'Sub Item'
    sub_item_number = '1-2-2'

    item = add_scene(item_name, item_number, exhibition[:id], exhibition[:id])
    Exhibitions::Service.register_order(exhibition[:id], item[:id], item_number)
    subscene = add_scene(sub_item_name, sub_item_number, item[:id], exhibition[:id])
    Exhibitions::Service.register_order(exhibition[:id], subscene[:id], sub_item_number)
    order = Exhibitions::Repository.retrieve(exhibition[:id]).order
    children = Items::Service.retrieve_by_parent(exhibition[:id], order)
    expect(children.first[:children][0][:name]).to eq sub_item_name
  end

  it 'retrieves an item by id and iso code' do
    name = 'scene name'
    number = '1-0-0'
    exhibition_id = exhibition[:id]

    scene = add_scene(name, number, exhibition_id, exhibition_id)
    scene_id = scene[:id]
    add_scene_languages(scene_id)

    translated_scene = Items::Service.merge_translation(scene_id, LOCALE)

    expect(translated_scene[:id]).to eq scene_id
    expect(translated_scene[:description] != scene[:description]).to be true
  end

  it 'stores all languages received' do
    name = 'scene name'
    number = '1-0-0'
    exhibition_id = exhibition[:id]

    scene = add_scene(name, number, exhibition_id, exhibition_id)
    scene_id = scene[:id]

    languages = add_scene_languages(scene_id)

    expect(languages[0][:name]).to eq 'nombre'
    expect(languages[1][:name]).to eq 'name'
    expect(languages[0][:iso_code]).to eq 'es'
    expect(languages[1][:iso_code]).to eq 'en'
  end

  def add_scene(name, number, parent_id, exhibition_id)
    scene = { 'id'=> '', 'name' => name, 'number' => number, 'parent_id' => parent_id, 'exhibition_id' => exhibition_id, 'type' => 'scene' }
    Items::Service.store_scene(scene)
  end

  def add_scene_languages(item_id)
    languages = [
        {'name' => 'nombre', 'description' => 'descripción', 'video' => 'video', 'iso_code' => 'es'},
        {'name' => 'name', 'description' => 'description', 'video' => 'video', 'iso_code' => 'en'}
    ]
    Items::Service.store_translations(languages, item_id)
  end

  def add_exhibition
    exhibition = { 'name' => 'name', 'location' => 'location' }
    Exhibitions::Service.store(exhibition)
  end
end
