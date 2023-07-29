# frozen_string_literal: true

class AhoyCaptain::TableComponent < ViewComponent::Base
  def initialize(items:, category_name:, unit_name:)
    @items = items
    @category_name = category_name
    @unit_name = unit_name
  end

  private

  attr_reader :items, :category_name, :unit_name

  def max_amount
    @max_amount ||= items.first.unit_amount
  end

  def total
    @total ||= items.first.total_count
  end
end
