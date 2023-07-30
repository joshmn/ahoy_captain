# frozen_string_literal: true

class AhoyCaptain::Filter::SelectComponent < ViewComponent::Base
  def initialize(label:, column:, url:, predicates:)
    @label = label
    @column = column
    @url = url
    @predicates = predicates
  end

  private

  attr_reader :label, :column, :url, :predicates
end
