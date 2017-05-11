require 'spec_helper_tdd'
require_relative '../../system/exhibitions/service'

describe Exhibitions::Service do
  before(:each) do
    flush
  end

  it 'retrieves exhibitions' do
    name = 'some name'
    type = 'some type'
    id = add_exhibition(name, type)

    exhibition = retrieve_exhibition(id)

    expect(exhibition[:name]).to eq(name)
    expect(exhibition[:type]).to eq(type)
  end

  it 'retrieves all exhibitions' do
    add_exhibition('some name')
    result = retrieve_all_exhibitions

    expect(result.any?).to be true
  end

  def retrieve_all_exhibitions
    Exhibitions::Service.list
  end

  def add_exhibition(name, type = 'Sculpture')
    exhibition = { 'id' => 'some_id', 'name' => name, 'type' => type }
    Exhibitions::Service.store(exhibition)
    exhibition['id']
  end

  def retrieve_exhibition(id)
    Exhibitions::Service.retrieve(id)
  end

  def flush
    Exhibitions::Service.flush
  end

end
