module AhoyCaptain
  class PredicateLabel
    def self.[](value)
      AhoyCaptain.config.predicate_labels[value.to_sym] || value.to_s.titleize
    end
  end
end
