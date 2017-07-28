require 'spec_helper_tdd'
require_relative '../../system/exhibitions/service'

describe Exhibitions::Service do
  before(:each) do
    Exhibitions::Repository.flush
  end

  it 'retrieves an exhibition with date creation' do
    name = 'some name'
    location = 'some location'
    result = add_exhibition(name, location)

    exhibition = Exhibitions::Service.retrieve(result[:id])

    expect(exhibition[:name]).to eq(name)
    expect(exhibition.include?(:creation_date)).to be true
  end

  it 'retrieve exhibition and children names' do
    name = 'some name'
    location = 'some location'
    result = add_exhibition(name, location)
    scene = add_scene('scene name', 'scene number', result[:id])
    room = add_room('room name', 'room number', result[:id])

    exhibition = Exhibitions::Service.retrieve_for_list(result[:id])

    expect(exhibition[:name]).to eq(name)
    expect(exhibition[:children]).to include({:id => scene[:id], :name => scene[:name], :number => scene[:number], :type => 'scene', :children => []})
    expect(exhibition[:children]).to include({:id => room[:id], :name => room[:name], :number => room[:number], :type => 'room', :children => []})
  end

  it 'retrieve ordered major level list of an exhibition' do
    name = 'some name'
    location = 'some location'
    exhibition = add_exhibition(name, location)
    scene = add_scene('scene name', '2.0.0', exhibition[:id])
    room = add_room('room name', '1.0.0', exhibition[:id])

    exhibition_list = Exhibitions::Service.retrieve_for_list(exhibition[:id])

    expect((exhibition_list[:children]).first).to include({:number => '1.0.0'})
  end

  it 'retrieve ordered minor level list of an exhibition' do
    name = 'some name'
    location = 'some location'
    exhibition = add_exhibition(name, location)
    room = add_room('room name', '1.0.0', exhibition[:id])
    scene_into_room = add_scene_into_room('scene name', '1.2.0', exhibition[:id], room[:id])
    other_scene_into_room = add_scene_into_room('scene name', '1.1.0', exhibition[:id], room[:id])

    exhibition_list = Exhibitions::Service.retrieve_for_list(exhibition[:id])

    expect((exhibition_list[:children][0][:children]).first).to include({:number => '1.1.0'})
  end

  it 'retrieves all exhibitions' do
    name = 'some name'
    location = 'some location'
    add_exhibition(name, location)

    result = Exhibitions::Service.list

    expect(result.any?).to be true
  end

  it 'defense of nullable parameters' do
    name = 'some name'
    location = nil
    result = add_exhibition(name, location)

    exhibition = Exhibitions::Service.retrieve(result[:id])

    expect(exhibition[:name]).to eq(name)
    expect(exhibition[:location]).to eq('')
  end

  def add_exhibition(name, location)
    exhibition = { 'name' => name, 'location' => location }
    Exhibitions::Service.store(exhibition)
  end

  def add_scene(name, number='', parent_id)
    scene = {'id' => '', 'name' => name, 'number' => number, 'parent_id' => parent_id, 'exhibition_id' => parent_id, 'parent_class' => 'exhibition',  'type' => 'scene' }
    Items::Service.store_scene(scene)
  end

  def add_scene_into_room(name, number, exhibition_id, room_id)
    scene = {'id' => '', 'name' => name, 'number' => number, 'parent_id' => room_id, 'exhibition_id' => exhibition_id, 'parent_class' => 'room',  'type' => 'scene' }
    Items::Service.store_scene(scene)
  end

  def add_room(name, number, exhibition_id)
    room = {'id' => '', 'name' => name, 'number' => number, 'parent_id' => exhibition_id, 'exhibition_id' => exhibition_id, 'parent_class' => 'exhibition', 'room' => true,  'type' => 'room' }
    Items::Service.store_room(room)
  end
end
