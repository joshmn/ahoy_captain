# frozen_string_literal: true

class AhoyCaptain::TableComponent < ViewComponent::Base
  DEFAULT_HEADER = AhoyCaptain::Tables::Headers::HeaderComponent
  DEFAULT_ROW = AhoyCaptain::Tables::Rows::RowComponent

  def initialize(items:, category_name: nil, unit_name: nil, header: nil, row: DEFAULT_ROW)
    @items = items
    @category_name = category_name
    @unit_name = unit_name
    @additional_cols = additional_cols
    if header.nil?
      @header = DEFAULT_HEADER.new(category_name: category_name, unit_name: unit_name)
    else
      @header = header.new
    end
    @row = row
  end

  def render_row(item)
    @row.new(table: self, item: item).render_in(view_context)
  end

  private

  attr_reader :items, :category_name, :unit_name, :additional_cols

  def max_amount
    @max_amount ||= items.first.unit_amount
  end

  def total
    @total ||= items.first.total_count
  end

  def fixed_height?
    !@header.is_a?(::AhoyCaptain::Tables::Headers::GoalsHeaderComponent)
  end
end
