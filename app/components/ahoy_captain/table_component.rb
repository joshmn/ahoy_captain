# frozen_string_literal: true

class AhoyCaptain::TableComponent < ViewComponent::Base
  SUPPORTED_COLS = [:percent_total, :total, :conversion_rate]

  def initialize(items:, category_name:, unit_name:, additional_cols: [])
    @items = items
    @category_name = category_name
    @unit_name = unit_name
    @additional_cols = additional_cols
  end

  private

  attr_reader :items, :category_name, :unit_name, :additional_cols

  def max_amount
    @max_amount ||= items.first.unit_amount
  end

  def total
    @total ||= items.first.total_count
  end

  def percent_total(item)
    '%.1f' % ((item.unit_amount.to_i * 1.0 / total)*100.0)
  end
end
