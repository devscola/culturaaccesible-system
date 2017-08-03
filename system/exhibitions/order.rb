class Order

  def initialize
    @index = {}
    @separator = '.'
  end

  def next_child (parent)
    return :error unless parent_exists?(parent)

    m = self.method('next_child_for_' + level(parent).to_s)
    next_child = m.call(parent)

    next_child
  end

  def register(ordinal, item_id)
    ordinal = ordinal
    @index[ordinal] = item_id
  end

  def retrieve_ordinal(item_id)
    @index.index(item_id)
  end

  private

  def get_elements
    @index.keys
  end

  def elements
    get_elements.map!{|element| to_array(element) }
  end

  def to_array(string)
    string.to_s.split(@separator).map{|e| e.to_i}
  end

  def to_string(array)
    array.join(@separator)
  end

  def parent_exists?(parent)
    return true if parent == '0.0.0'
    parent = to_array(parent)
    elements.find{ |element| element == parent}
  end

  def next_child_for_exhibition(parent=nil)
    next_mayor = elements.empty? ? 1 : elements.last.first + 1
    to_string [next_mayor, 0, 0]
  end

  def next_child_for_mayor(parent)
    parent_mayor = to_array(parent)[0]
    children = elements.select {|e| e[0] == parent_mayor}
    next_minor = children.empty? ? 1 : children.last[1] + 1
    to_string [parent_mayor, next_minor, 0]
  end

  def next_child_for_minor(parent)
    parent_mayor = parent.to_s.to_s.split(@separator)[0].to_i
    parent_minor = parent.to_s.split(@separator)[1].to_i
    children = elements.select {|e| e[0] == parent_mayor && e[1] == parent_minor}
    next_detail = children.empty? ? 1 : children.last[2] + 1
    to_string [parent_mayor, parent_minor, next_detail]
  end

  def level(parent)
    parent_elements = parent.to_s.split(@separator)
    return :minor if(parent_elements[1] != '0')
    return :mayor if(parent_elements[0] != '0')
    return :exhibition
  end

end
