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
    add_item('first name', 'first number', result[:id])
    add_item('second name', 'second number', result[:id], 'author name')

    exhibition = Exhibitions::Service.retrieve_for_list(result[:id])

    expect(exhibition[:name]).to eq(name)
    expect(exhibition[:children].first[:name]).to eq('first name')
    expect(exhibition[:children].first[:type]).to eq('room')
    expect(exhibition[:children].last[:name]).to eq('second name')
    expect(exhibition[:children].last[:type]).to eq('item')
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

  def add_item(name, number, exhibition_id, author='')
    item = { 'name' => name, 'number' => number, 'parent_id' => exhibition_id, 'author' => author }
    Items::Service.store_item(item)
  end
end
