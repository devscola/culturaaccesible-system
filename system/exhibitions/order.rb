class Order

  def initialize
    @elements = []
    @separator = '.'
  end


  def add_element (el)
    parts = el.split(@separator)
    @elements << parts.map!{|e| e.to_i}
  end

  def next_child (parent)
    return :error unless parent_exists?(parent)

    m = self.method('next_child_for_' + level(parent).to_s)
    next_child = m.call(parent)
    add_element(next_child)
    next_child
  end

  private

  def elements
    @elements.sort
  end

  def to_array(string)
    string.split(@separator).map{|e| e.to_i}
  end

  def to_string(array)
    array.join(@separator)
  end

  def parent_exists?(parent)
    return true if parent == '0.0.0'
    parent = to_array(parent)
    elements.find{ |e| e == parent}
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
    parent_mayor = parent.split(@separator)[0].to_i
    parent_minor = parent.split(@separator)[1].to_i
    children = elements.select {|e| e[0] == parent_mayor && e[1] == parent_minor}
    next_detail = children.empty? ? 1 : children.last[2] + 1
    to_string [parent_mayor, parent_minor, next_detail]
  end

  def level(parent)
    parent_elements = parent.split(@separator)
    return :minor if(parent_elements[1] != '0')
    return :mayor if(parent_elements[0] != '0')
    return :exhibition
  end

end