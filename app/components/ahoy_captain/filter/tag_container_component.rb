# frozen_string_literal: true

class AhoyCaptain::Filter::TagContainerComponent < ViewComponent::Base
  def initialize(filters)
    @filters = filters
  end

  private
  attr_reader :filters
end
