# frozen_string_literal: true

class AhoyCaptain::Filter::TagContainerComponent < ViewComponent::Base
  def initialize(filters:)
    @filters = filters.to_unsafe_h.to_a.map do |key, values|
      Array(values).map { |value| [key, value] }
    end.flatten(1).reject { |k,v| v.blank? }

  end

  private
  attr_reader :filters
end
