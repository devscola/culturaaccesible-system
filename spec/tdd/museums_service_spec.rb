require 'spec_helper_tdd'
require_relative '../../system/museums/service'

describe Museums::Service do

  SPANISH = 'es'

  it 'retrieves a museum' do
    name = 'some name'
    description = 'some description'
    museum = add_museum(name, description)

    museum = Museums::Service.retrieve(museum[:id])

    expect(museum[:info][:name]).to eq(name)
    expect(museum[:info][:description]).to eq(description)
  end

  it 'retrieve translated museum' do
    name = 'some name'
    description = 'some description'
    museum = add_museum(name, description)
    Museums::Service.store_translations(museum_languages, museum[:id])

    translated_museum = Museums::Service.retrieve_translated(museum[:id], 'es')

    expect(translated_museum[:id]).to eq museum[:id]
    expect(translated_museum[:info][:description]).to eq 'descripción'
  end

  it 'stores translated museum' do
    name = 'some name'
    description = 'some description'
    museum = add_museum(name, description)
    translations = add_translations(museum[:id])

    expect(translations[0][:iso_code]).to eq 'es'
    expect(translations[1][:iso_code]).to eq 'en'
    expect(translations[0][:description]).to eq 'descripción'
    expect(translations[1][:description]).to eq 'description'
    expect(museum[:info][:name]).to eq 'some name'
  end

  it 'retrieve museum with translations' do
    name = 'some name'
    description = 'some description'
    museum = add_museum(name, description)
    translations = add_translations(museum[:id])

    museum = Museums::Service.retrieve_translations(museum[:id])

    expect(museum[0][:iso_code]).to eq 'es'
    expect(museum[1][:iso_code]).to eq 'en'
    expect(museum[0][:description]).to eq 'descripción'
    expect(museum[1][:description]).to eq 'description'
  end

  it 'retrieves all museums' do
    add_museum('some name', 'some description')
    result = retrieve_all_museums(SPANISH)

    expect(result.any?).to be true
  end

  it 'updates a museum' do
    museum = add_museum('some name', 'some description')
    updated_museum = add_museum(museum[:id], 'some other name', 'some other description')

    expect(museum[:id]).to eq updated_museum[:id]
    expect(updated_museum[:info][:name]).to eq('some other name')
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

  def retrieve_all_museums(iso_code)
    Museums::Service.list(iso_code)
  end

  def add_museum(id = false, name, description)
    museum_data = { 'id' => id, 'info' => { 'name' => name, 'description' => description } }
    Museums::Service.store(museum_data)
  end

  def add_translations(museum_id)
    translations = museum_languages
    Museums::Service.store_translations(translations, museum_id)
  end

  def add_nil_museum_content(name, phone, description)
    museum_data = { 'info' => { 'name' => name, 'description' => description }, 'contact' => { 'phone' => phone } }
    Museums::Service.store(museum_data)
  end

  def museum_languages
    [
      {'description' => 'descripción', 'iso_code' => 'es'},
      {'description' => 'description', 'iso_code' => 'en'}
    ]
  end
end
