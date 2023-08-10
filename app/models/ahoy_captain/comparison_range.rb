module AhoyCaptain
  class ComparisonRange
    def self.build(range)
      [range[0] - (range[1] - range[0]), range[0]]
    end
  end
end
