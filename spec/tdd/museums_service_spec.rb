require 'spec_helper_tdd'
require_relative '../../system/museums/service'

describe Museums::Service do
  it 'retrieves a museum' do
    name = 'some name'
    description = 'some description'
    museum = add_museum(name, description)

    museum = Museums::Service.retrieve(museum[:id])

    expect(museum[:info][:name]).to eq(name)
    expect(museum[:info][:description]).to eq(description)
  end

  it 'retrieves all museums' do
    add_museum('some name', 'some description')
    result = retrieve_all_museums

    expect(result.any?).to be true
  end

  it 'updates a museum' do
    museum = add_museum('some name', 'some description')
    updated_museum = update_museum(museum[:id])

    expect(museum[:id]).to eq updated_museum[:id]
  end

  it 'defense of nullable parameters' do
    name = 'Musium'
    description = nil
    phone = nil
    museum = add_nil_museum_content(name, phone, description)

    museum = Museums::Service.retrieve(museum[:id])

    expect(museum[:info][:description]).to eq('')
    expect(museum[:contact][:phone]).to eq([])
  end

  def retrieve_all_museums
    Museums::Service.list
  end

  def add_museum(name, description)
    museum_data = { 'info' => { 'name' => name, 'description' => description } }
    Museums::Service.store(museum_data)
  end

  def update_museum(id)
    museum_data = { 'id' => id, 'info' => { 'name' => 'updated name', 'description' => 'updated description' } }
    Museums::Service.update(museum_data)
  end

  def add_nil_museum_content(name, phone, description)
    museum_data = { 'info' => { 'name' => name, 'description' => description }, 'contact' => { 'phone' => phone } }
    Museums::Service.store(museum_data)
  end
end
