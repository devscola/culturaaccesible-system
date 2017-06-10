require 'spec_helper_tdd'
require_relative '../../system/museums/service'

describe Museums::Service do
  it 'retrieves a museum' do
    name = 'some name'
    description = 'some description'
    add_museum(name, description)

    museum = Museums::Service.retrieve(name)

    expect(museum[:info][:name]).to eq(name)
    expect(museum[:info][:description]).to eq(description)
  end

  it 'retrieves all museums' do
    add_museum('some name', 'some description')
    result = retrieve_all_museums

    expect(result.any?).to be true
  end

  def retrieve_all_museums
    Museums::Service.list
  end

  def add_museum(name, description)
    museum_data = { 'info' => { 'name' => name, 'description' => description } }
    Museums::Service.store(museum_data)
  end
end
