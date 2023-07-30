# frozen_string_literal: true

class AhoyCaptain::Filter::TagComponent < ViewComponent::Base
  PREDICATES = {
    eq: 'equals',
    not_eq: 'not equals',
    cont: 'contains',
    in: 'in',
    not_in: 'not in',
  }
  def initialize(column_predicate:, category:)
    @column_predicate = column_predicate
    @category = category
  end

  def url
    search_params = helpers.search_params.deep_dup
    search_params["q"][@column_predicate] = search_params["q"][@column_predicate] - [@category]

    request.path + "?" + search_params.to_query
  end

  private
  attr_reader :column_predicate, :category

  def column_with_predicate
    PREDICATES.keys.map(&:to_s).each do |predicate|
      if column_predicate.include?(predicate)
        before, match, after = column_predicate.partition(predicate)
        return [before.gsub('_',' '), PREDICATES[match.to_sym]].join(' ').humanize
      end
    end
  end
end
