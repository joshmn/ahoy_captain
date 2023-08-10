module AhoyCaptain
  module ComparableQueries
    def compare_range
      @compare_range ||= begin
                           og_range = range
                           [og_range[0] - (og_range[1] - og_range[0]), og_range[0]]
                         end
    end

    def range
      @range ||= @query.send(:range)
    end

    def comparison_params
      params = @params.deep_dup
      params.delete("period")

      params[:start_date] = compare_range[0]
      params[:end_date] = compare_range[1]
      params
    end
  end
end

require_relative '../concerns/lazy_comparable_query'
require_relative '../concerns/comparable_query'
