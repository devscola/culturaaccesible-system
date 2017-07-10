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
    item = add_item('item name', 'item number', result[:id])
    room = add_room('room name', 'room number', result[:id])

    exhibition = Exhibitions::Service.retrieve_for_list(result[:id])

    expect(exhibition[:name]).to eq(name)
    expect(exhibition[:children]).to include({:id => item[:id], :name => item[:name], :type => 'item'})
    expect(exhibition[:children]).to include({:id => room[:id], :name => room[:name], :type => 'room'})
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

  def add_item(name, number, parent_id)
    item = { 'name' => name, 'number' => number, 'parent_id' => parent_id, 'exhibition_id' => parent_id, 'parent_class' => 'exhibition' }
    Items::Service.store_item(item)
  end

  def add_room(name, number, exhibition_id)
    room = { 'name' => name, 'number' => number, 'parent_id' => exhibition_id, 'exhibition_id' => exhibition_id, 'parent_class' => 'exhibition', 'room' => true }
    Items::Service.store_room(room)
  end
end
