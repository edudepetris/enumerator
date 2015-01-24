require 'spec_helper'

class ArrayWrapper
  include CustomEnumerable

  def initialize(*items)
    @items = items.flatten
  end

  #
  # TODO maybe here I can use tap
  def each(&block)
    @items.each(&block)
    self
  end

  def ==(other)
    @items == other
  end
end

describe CustomEnumerable do

  context '#map' do
    it 'maps the numbers multiplying them by 2' do
      items  = ArrayWrapper.new(1,2,3,4)
      result = items.map { |n| n*2 }
      expect(result).to eq([2, 4, 6, 8])
    end
  end

  context '#find' do
    it 'finds the item given a predicate' do
      items  = ArrayWrapper.new(1, 2, 3, 4)
      result = items.find { |element| element == 3 }
      expect(result).to eq(3)
    end

    it 'returns the ifnone value if no item is found' do
      items  = ArrayWrapper.new(1, 2, 3, 4)
      result = items.find(lambda {0}) { |element| element < 1 }
      expect(result).to eq(0)
    end

    it "returns nil if it can't find anything" do
      items  = ArrayWrapper.new(1, 2, 3, 4)
      result = items.find {|element| element == 10 }
      expect(result).to be_nil
    end
  end

  context '#find_all' do
    it 'finds all numbers that are even' do
      items  = ArrayWrapper.new(1,2,3,4,5,6)
      result = items.find_all { |element| element.even? }
      expect(result).to eq([2,4,6])
    end

    it 'does not find anything' do
      items  = ArrayWrapper.new(1,2,3,4,5,6)
      result = items.find_all { |element| element > 8 }
      expect(result).to be_empty
    end
  end

  context '#reduce' do
    it 'sums all items' do
      items  = ArrayWrapper.new(1,2,3,4,5)
      result = items.reduce(0) { |acumulator, element| acumulator + element }
      expect(result).to eq(15)
    end

    it 'returns the acumulator if no values was provide' do
      items  = ArrayWrapper.new
      result = items.reduce(10) { |acumulator, element| acumulator + element }
      expect(result).to eq(10)
    end

    it 'executes the operation provided' do
      items  = ArrayWrapper.new(1, 2, 3, 4, 5)
      result = items.reduce(0, :+)
      expect(result).to eq(15)
    end

    it "fails if both a symbol and a block are provided" do
      items = ArrayWrapper.new(1, 2, 3, 4, 5)
      expect do
        items.reduce(0, :+) { |accumulator,element| accumulator + element }
      end.to raise_error(ArgumentError, "you must provide either an operation symbol or a block, not both")
    end

    it 'fails if the operation provided is not a symbol' do
      items = ArrayWrapper.new(1, 2, 3, 4, 5)
      expect do
        items.reduce(0, '+')
      end.to raise_error(ArgumentError, "the operation provided must be a symbol")
    end

    it 'executes the operation provided without an initial value' do
      items = ArrayWrapper.new(1, 2, 3, 4, 5)
      result = items.reduce(:+)
      expect(result).to eq(15)
    end

    it 'executes the block provided without an initial value' do
      items = ArrayWrapper.new(1, 2, 3, 4, 5)
      result = items.reduce { |accumulator, element| accumulator + element }
      expect(result).to eq(15)
    end
  end

  context '#max' do
    it 'produces nil if it is empty' do
      items = ArrayWrapper.new
      expect(items.max).to be_nil
    end

    it 'produces 10 as the max result' do
      items = ArrayWrapper.new(1,2,3,4,10)
      expect(items.max).to eq(10)
    end
  end

  context '#min' do
    it 'produces nil if it is empty' do
      items = ArrayWrapper.new
      expect(items.min).to be_nil
    end

    it 'produces -5 as the min result' do
      items = ArrayWrapper.new(1,2,3,4,-5)
      expect(items.min).to eq(-5)
    end
  end

  context '#each_with_index' do
    it 'pending' do
    end
  end

  context '#count' do
    it 'pending' do
    end
  end

end
