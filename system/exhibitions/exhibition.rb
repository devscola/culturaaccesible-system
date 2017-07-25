module Exhibitions
  class Exhibition
    attr_reader :id, :name, :order
    attr_accessor :numbers

    def initialize(data, id=nil)
      @creation_date = Time.now.utc
      @show = Defense.string_null_defense(data['show'])
      @name = Defense.string_null_defense(data['name'])
      @location = Defense.string_null_defense(data['location'])
      @short_description = Defense.string_null_defense(data['short_description'])
      @date_start = Defense.string_null_defense(data['date_start'])
      @date_finish = Defense.string_null_defense(data['date_finish'])
      @type = Defense.string_null_defense(data['type'])
      @numbers = Defense.array_null_defense(data['numbers'])
      @beacon = Defense.string_null_defense(data['beacon'])
      @description = Defense.string_null_defense(data['description'])
      @id = id || generate_id
      @index = []
      @order = Order.new
    end

    def serialize
      {
        creation_date: @creation_date,
        id: @id,
        show: @show,
        name: @name,
        location: @location,
        short_description: @short_description,
        date_start: @date_start,
        date_finish: @date_finish,
        type: @type,
        numbers: @numbers,
        beacon: @beacon,
        description: @description,
        index: @index
      }
    end

    def get_numbers
      @numbers
    end

    def set_numbers(number)
      @numbers << number
    end

    def remove_number(number)
      @numbers.delete(number)
    end

    def update_order(new_number, last_number, exhibition_id)
      order = Order.new
      new_number = order.to_array(new_number)
      last_number = order.to_array(last_number)

      @numbers.map! do |number|
        iteration_last_number = number
        number = order.to_array(number)
        detail_changed = change_detail(number, new_number, last_number)
        minor_changed = change_minor(number, new_number, last_number) if detail_changed || three_times_not_changed?(new_number, last_number)
        major_changed = change_major(number, new_number, last_number) if minor_changed || twice_not_changed?(new_number, last_number)
        number = order.to_string(number)
        if major_changed || minor_changed || detail_changed
          relation = Items::Repository.retrieve_relation(iteration_last_number, exhibition_id)
          update_item(relation, iteration_last_number, number)
        end
        number
      end
    end

    def update_item(relation, iteration_last_number, number)
      id = ''
      if relation != nil
        serialized_relation = relation.serialize
        if(serialized_relation.key?(iteration_last_number))
          id = serialized_relation[iteration_last_number]
        end
        item = Items::Repository.retrieve(id)
        item.relation.order(number)
        item.relation.id(id)
        item.set_number(number)
      end
    end

    def change_detail(number, new_number, last_number)
      changed = false
      if( detail_change?(number, last_number) &&
          minor_change?(number,last_number) &&
          major_change?(number, last_number))
        number[2] = new_number[2]
        changed = true
      end
      changed
    end

    def change_minor(number, new_number, last_number)
      changed = false
      if( minor_change?(number, last_number) &&
          major_change?(number,last_number))
          number[1] = new_number[1]
          changed = true
      end
      changed
    end

    def change_major(number, new_number, last_number)
      changed = false
      if(major_change?(number, last_number))
        number[0] = new_number[0]
        changed = true
      end
      changed
    end

    def major_change?(number, last_number)
      (number[0] == last_number[0])
    end

    def minor_change?(number, last_number)
      (number[1] == last_number[1])
    end

    def detail_change?(number, last_number)
      (number[2] == last_number[2])
    end

    def twice_not_changed?(new_number, last_number)
      return true if (new_number[0] == last_number[0] ||
                      new_number[1] == last_number[1])
    end

    def three_times_not_changed?(new_number, last_number)
      return true if (new_number[0] == last_number[0] ||
                      new_number[1] == last_number[1] ||
                      new_number[2] == last_number[2])
    end

    private

    def generate_id
      Digest::MD5.hexdigest(@creation_date.to_s + @creation_date.nsec.to_s + @name)
    end
  end
end
