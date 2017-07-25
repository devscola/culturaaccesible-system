module Items
  class Relation

    def initialize(new_order, id, exhibition_id)
      @id = id
      @order = new_order
      @exhibition_id = exhibition_id
    end

    def serialize
      {
        @order => @id
      }
    end

    def get_order
      @order
    end

    def get_exhibition_id
      @exhibition_id
    end

    def order(order)
      @order = order
    end

    def id(id)
      @id = id
    end

  end
end
