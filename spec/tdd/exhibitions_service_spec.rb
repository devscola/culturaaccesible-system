require 'spec_helper_tdd'
require_relative '../../system/exhibitions/service'

describe Exhibitions::Service do
  before(:each) do
    Exhibitions::Repository.flush
  end

  it 'retrieves an exhibition with date creation' do
    name = 'some name'
    result = add_exhibition(name)

    exhibition = Exhibitions::Service.retrieve(result[:id])

    expect(exhibition[:name]).to eq(name)
    expect(exhibition.include?(:creation_date)).to be true
  end

  it 'retrieves an exhibition by id and iso code' do
    name = 'english name'
    exhibition = add_exhibition(name)
    add_translations(exhibition[:id])

    iso_code = 'es'
    translated_exhibition = Exhibitions::Service.retrieve_translated(exhibition[:id], iso_code)

    expect(translated_exhibition[:id]).to eq exhibition[:id]
    expect(translated_exhibition[:name] != exhibition[:name]).to be true
  end

  it 'retrieves all exhibitions' do
    name = 'some name'
    add_exhibition(name)

    result = Exhibitions::Service.list

    expect(result.any?).to be true
  end

  it 'defense of nullable parameters' do
    name = 'some name'
    museum_id = nil
    result = add_exhibition(name, museum_id)

    exhibition = Exhibitions::Service.retrieve(result[:id])

    expect(exhibition[:name]).to eq(name)
    expect(exhibition[:museum_id]).to eq('')
  end

  it 'deletes an exhibition' do
    name = 'some name'
    exhibition = add_exhibition(name)

    exhibition = Exhibitions::Service.delete(exhibition[:id])

    expect(exhibition[:deleted]).to be true
  end

  def add_exhibition(name, museum_id = 1)
    exhibition = { 'name' => name, 'museum_id' => museum_id }
    Exhibitions::Service.store(exhibition)
  end

  def add_translations(exhibition_id)
    translations = exhibition_languages
    Exhibitions::Service.store_translations(translations, exhibition_id)
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

  def exhibition_languages
    [
      {'name' => 'nombre', 'description' => 'descripción', 'short_description' => 'descripcion corta', 'iso_code' => 'es'},
      {'name' => 'name', 'description' => 'description', 'short_description' => 'short description', 'iso_code' => 'en'}
    ]
  end
end
