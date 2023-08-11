module AhoyCaptain
  class DashboardPresenter
    include Rangeable
    include RangeOptions
    include CompareMode

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def unique_visitors
      Stats::UniqueVisitorsQuery.call(params).with_comparison(compare_mode?).count
    end

    def total_visits
      Stats::TotalVisitorsQuery.call(params).with_comparison(compare_mode?).count
    end

    def total_pageviews
      Stats::TotalPageviewsQuery.call(params).with_comparison(compare_mode?).count
    end

    def views_per_visit
      Stats::AverageViewsPerVisitQuery.call(params).with_comparison(compare_mode?).count("count")
    end

    def bounce_rate
      query = Stats::BounceRatesQuery.call(params)
      if compare_mode?
        query.with_comparison(true)
      else
        query.average("bounce_rate").try(:round, 2) || 0
      end
    end

    def visit_duration
      query = Stats::AverageVisitDurationQuery.call(params)
      if compare_mode?
        query.with_comparison(true)
      else
        query[0].average_visit_duration
      end
    end

    private

    def compare_mode?
      params[:comparison] != 'false'
    end
  end
end
