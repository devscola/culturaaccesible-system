require 'spec_helper_tdd'
require_relative '../../system/museums/service'

describe Museums::Service do

  it 'retrieve a museum' do
    name = 'some name'
    description = 'some description'

    museum = add_museum(name, description)

    expect(museum[:name]).to eq(name)
    expect(museum[:description]).to eq(description)
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
    museum_data = { 'id' => 'some id', 'name' => name, 'description' => description }
    Museums::Service.store(museum_data)
    retrieve_museum(museum_data['id'])
  end

  def retrieve_museum(id)
    Museums::Service.retrieve(id)
  end
end