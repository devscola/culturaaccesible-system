module Actions
  class Exhibition
    class << self
      def retrieve_for_list(exhibition)
        children = Items::Service.retrieve_by_parent(exhibition[:id])
        children.map! do |item|
          {
            id: item[:id],
            name: item[:name],
            type: item[:type],
            number: item[:number],
            children: Items::Service.retrieve_by_parent(item[:id])
          }
        end
        sorted_children = Exhibitions::Service.sort_list(children)
        { id: exhibition[:id], name: exhibition[:name], :children => sorted_children }
      end
    end
  end
end
