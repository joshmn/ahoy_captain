# frozen_string_literal: true

class AhoyCaptain::Filter::SelectComponent < ViewComponent::Base
  def initialize(label:, column:, url:, predicates:, form:, multiple: true)
    @label = label
    @column = column
    @url = url
    @predicates = predicates
    @form = form
    @multiple = multiple
  end

  private

  def selected_predicate?(predicate)
    params.dig(:q, predicate_name(predicate)).present?
  end

  def option_value(predicate)
    name = "q[#{predicate_name(predicate)}]"
    name += "[]" if multiple
    name
  end

  def predicate_name(predicate)
    "#{@column}_#{predicate}"
  end

  def selected_predicate
    @predicates.each do |predicate|
      if params.dig(:q, predicate_name(predicate))
        return predicate
      end
    end

    nil
  end

  def column_name_with_predicate
    if selected_predicate
      option_value(selected_predicate)
    else
      option_value(@predicates.first)
    end
  end

  def values
    @predicates.each do |predicate|
      option = params.dig(:q, predicate_name(predicate))
      if option
        return option
      end
    end

    []
  end

  attr_reader :label, :column, :url, :predicates, :form, :multiple
end
