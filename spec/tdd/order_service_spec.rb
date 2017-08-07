require 'spec_helper_tdd'
require_relative '../../system/exhibitions/order'

describe Order do

  it 'returns 1-0-0 when no elements' do
    order = Order.new

    result = order.next_child('0-0-0')

    expect(result).to eq('1-0-0')
  end

  it 'returns next mayor element' do
    order = Order.new
    order.register('1-0-0', 'fakeItemId')

    result = order.next_child('0-0-0')

    expect(result).to eq('2-0-0')
  end

  it 'returns 3-1-0 for 3-0-0 when no 3.x exists' do
    order = Order.new
    order.register('2-4-0', 'fakeItemId')
    order.register('3-0-0', 'fakeItemId')
    order.register('4-0-0', 'fakeItemId')

    result = order.next_child('3-0-0')

    expect(result).to eq('3-1-0')
  end

  it 'returns 3.5.0 when max for mayor 3 is 3.4.x' do
    order = Order.new
    order.register('3-0-0', 'fakeItemId')
    order.register('3-4-0', 'fakeItemId')
    order.register('4-0-0', 'fakeItemId')

    result = order.next_child('3-0-0')

    expect(result).to eq('3-5-0')
  end

  it 'returns 3.5.1 for 3.5.0 when no 3.5.x exists' do
    order = Order.new
    order.register('3-6-0', 'fakeItemId')
    order.register('3-5-0', 'fakeItemId')
    order.register('3-4-0', 'fakeItemId')

    result = order.next_child('3-5-0')

    expect(result).to eq('3-5-1')
  end

  it 'returns two elements for all levels' do
    order = Order.new

    order.register('1-0-0', 'fakeItemId')
    result = order.next_child('1-0-0')
    expect(result).to eq('1-1-0')

    order.register('2-0-0', 'fakeItemId')
    result = order.next_child('2-0-0')
    expect(result).to eq('2-1-0')

    order.register('1-1-0', 'fakeItemId')
    result = order.next_child('1-1-0')
    expect(result).to eq('1-1-1')

    order.register('1-2-0', 'fakeItemId')
    result = order.next_child('1-2-0')
    expect(result).to eq('1-2-1')
  end

  it 'returns Error if parent not exists' do
    order = Order.new

    result = order.next_child('3-0-0')

    expect(result).to eq(:error)
  end
end
