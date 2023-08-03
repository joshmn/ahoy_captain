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

  def selected_predicate
    predicate_options.detect { |option| params.dig(:q, option) }
  end

  def column_name_with_predicate
    name = if selected_predicate
             "q[#{selected_predicate}]"
           else
             "q[#{predicate_options.first}]"
           end

    if multiple
      name += "[]"
    end

    name
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

  private attr_reader :label, :column, :url, :predicates, :form, :multiple
end
