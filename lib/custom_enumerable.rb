module CustomEnumerable

  # TODO Add tap to avoid the last line
  def map(&block)
    result = []
    each do |element|
      result <<  block.call(element)
    end
    result
  end

  def find(ifnone=nil, &block)
    found  = false
    result = nil
    each do |element|
      if block.call(element)
        result = element
        found  = true
        break
      end
    end
    found ? result : ifnone && ifnone.call
  end

  def find_all(&block)
    result = []
    each do |element|
      if block.call(element)
        result << element
      end
    end
    result
  end

  def first
    each do |element|
      return element
    end
    nil
  end

  def reduce(accumulator = nil, operation = nil, &block)
    if accumulator.nil? && operation.nil? && block.nil?
      raise ArgumentError, "you must provide an operation or a block"
    end

    if operation && block
      raise ArgumentError, "you must provide either an operation symbol or a block, not both"
    end

    if operation.nil? && block.nil?
      operation = accumulator
      accumulator = nil
    end

    block = case operation
    when Symbol
      lambda { |acc, value| acc.send(operation, value) }
    when nil
      block
    else
      raise ArgumentError, "the operation provided must be a symbol"
    end

    if accumulator.nil?
      ignore_first = true
      accumulator = first
    end

    index = 0

    each do |element|
      unless ignore_first && index == 0
        accumulator = block.call(accumulator, element)
      end
      index += 1
    end
    accumulator
  end

  def max
    reduce do |accumulator, element|
      accumulator > element ? accumulator : element
    end
  end

  def min
    reduce do |accumulator, element|
      accumulator < element ? accumulator : element
    end
  end

  def count(item = nil, &block)
    if item && block
      raise ArgumentError, 'given block not used'
    end

    reduce(0) do |accumulator, element|
      if block_given?
        accumulator + (block.call(element) ? 1 : 0)
      elsif item
        accumulator + (item == element ? 1 : 0)
      else
        accumulator + 1
      end
    end
  end
end
