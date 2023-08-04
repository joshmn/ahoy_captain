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

  def selected_predicate
    predicate_options.detect { |option| params.dig(:q, option) }
  end

  def option_value(predicate)
    name = "q[#{predicate}]"
    name += "[]" if multiple
    name
  end

  def column_name_with_predicate
    if selected_predicate
      option_value(selected_predicate)
    else
      option_value(predicate_options.first)
    end
  end

  def values
    predicate_options.each do |predicate|
      option = params.dig(:q, predicate)
      if option
        return option
      end
    end

    []
  end

  def predicate_options
    @predicate_options ||= @predicates.map { |predicate| "#{@column}_#{predicate}" }
  end

  attr_reader :label, :column, :url, :predicates, :form, :multiple
end
