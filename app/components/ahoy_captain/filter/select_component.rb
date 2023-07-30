# frozen_string_literal: true

class AhoyCaptain::Filter::SelectComponent < ViewComponent::Base
  def initialize(label:, column:, url:, predicates:)
    @label = label
    @column = column
    @url = url
    @predicates = predicates
  end

  def selected_predicate
    predicate_options.detect { |option| params.dig(:q, option) }
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

  private

  def predicate_options
    @predicate_options ||= @predicates.map { |predicate| "#{@column}_#{predicate}" }
  end
  attr_reader :label, :column, :url, :predicates
end
