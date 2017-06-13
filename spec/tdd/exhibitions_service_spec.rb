require 'spec_helper_tdd'
require_relative '../../system/exhibitions/service'

describe Exhibitions::Service do
  before(:each) do
    Exhibitions::Repository.flush
  end

  it 'retrieves an exhibition' do
    name = 'some name'
    location = 'some location'
    add_exhibition(name, location)

    exhibition = Exhibitions::Service.retrieve(name)

    expect(exhibition[:name]).to eq(name)
    expect(exhibition[:location]).to eq(location)
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
    add_exhibition(name, location)

    exhibition = Exhibitions::Service.retrieve(name)

    expect(exhibition[:name]).to eq(name)
    expect(exhibition[:location]).to eq('')
  end

  def add_exhibition(name, location)
    exhibition = { 'name' => name, 'location' => location }
    Exhibitions::Service.store(exhibition)
  end
end
