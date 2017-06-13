class Defense
  class << self
    def string_null_defense(value)
      value || ''
    end

    def array_null_defense(value)
      value || []
    end
  end
end
