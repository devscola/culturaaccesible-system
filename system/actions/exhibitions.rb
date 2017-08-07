module Actions
  class Exhibition
    class << self
      def retrieve_for_list(exhibition)
        order = Exhibitions::Repository.retrieve(exhibition[:id]).order
        children = Items::Service.retrieve_by_parent(exhibition[:id])
        children.map! do |item|
          {
            id: item[:id],
            name: item[:name],
            number: order.retrieve_ordinal(item[:id]),
            type: item[:type],
            children: retrieve_subitems_by_parent(exhibition[:id], item[:id])
          }
        end
        sorted_children = Exhibitions::Service.sort_list(children)
        { id: exhibition[:id], name: exhibition[:name], :children => sorted_children }
      end

      def retrieve_subitems_by_parent(exhibition_id, item_id)
        order = Exhibitions::Repository.retrieve(exhibition_id).order
        children = Items::Repository.retrieve_by_parent(item_id)
        children.map! do |item|
          {
            id: item[:id],
            name: item[:name],
            type: item[:type],
            number: order.retrieve_ordinal(item[:id]),
            children: sorted_subitems(order, item[:id])
          }
        end
        sorted_children = Exhibitions::Service.sort_list(children)
        sorted_children
      end

      def sorted_subitems(order, item_id)
        subitems = Items::Repository.retrieve_by_parent(item_id)
        subitems.map! do |subitem|
          {
            id: subitem[:id],
            name: subitem[:name],
            type: subitem[:type],
            number: order.retrieve_ordinal(subitem[:id])
          }
        end
        Exhibitions::Service.sort_list(subitems)
      end
    end
  end
end
