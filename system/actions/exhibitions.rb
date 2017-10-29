module Actions
  class Exhibition
    class << self
      def retrieve_for_list(exhibition)
        order = Exhibitions::Repository.retrieve(exhibition[:id]).order
        children = Items::Service.retrieve_by_parent(exhibition[:id], order)
        children.map! do |item|
          begin
            {
              id: item[:id],
              name: item[:name],
              number: item[:number],
              type: item[:type],
              children: item[:children]
            }
          rescue
            next
          end
        end
        children.reject!{ |child| child == nil }
        sorted_children = Exhibitions::Service.sort_list(children)
        { id: exhibition[:id], name: exhibition[:name], creation_date: exhibition[:creation_date], :children => sorted_children }
      end

      def retrieve_all_items( exhibition, iso_code )
        children = Items::Service.retrieve_all_translated_items( exhibition[:id], iso_code )
        children.map! do | item |
          begin
            {
              id: item[:id],
              name: item[:name] || '',
              author: item[:author] || '',
              date: item[:date] || '',
              beacon: item[:beacon] || '',
              description: item[:description] || '',
              image: item[:image] || '',
              video: item[:video] || '',
              parent_id: item[:parent_id] || '',
              parent_class: item[:parent_class] || '',
              type: item[:type] || '',
              children: item[:children]
            }
          rescue
            next
          end
        end
        children.reject!{ |child| child == nil }
        Exhibitions::Service.sort_list(children)
      end

      def delete_item(item_id, exhibition_id)
        exhibition = Exhibitions::Repository.retrieve(exhibition_id)

        order = exhibition.order
        order.delete(item_id)

        children = Items::Repository.retrieve_by_parent(item_id)

        children.each do |child|
          order.delete(child[:id])

          subchildren = Items::Repository.retrieve_by_parent(child[:id])
          subchildren.each do |subchild|
            order.delete(subchild[:id])
          end
        end

        Exhibitions::Repository.update_exhibition(exhibition)
      end

      def add_museum_info(exhibition)
        museum = Museums::Repository.retrieve(exhibition[:museum_id]).serialize
        data = {
          id: museum[:id],
          name: museum[:info][:name]
        }
        exhibition[:museum] = data
        exhibition.delete(:museum_id)
        exhibition
      end
    end
  end
end
