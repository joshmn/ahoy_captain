module AhoyCaptain
  class DashboardPresenter
    include RangeOptions

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def unique_visitors
      Stats::UniqueVisitorsQuery.call(params).with_comparison.count
    end

    def total_visits
      Stats::TotalVisitorsQuery.call(params).with_comparison.count
    end

    def total_pageviews
      Stats::TotalPageviewsQuery.call(params).with_comparison.count
    end

    def views_per_visit
      cached(:views_per_visit) do
        begin
          result = Stats::AverageViewsPerVisitQuery.call(params).count(:id)
          count = (result.values.sum.to_f / result.size).round(2)
          if count.nan?
            return "0"
          else
            return count
          end
        rescue ::ActiveRecord::StatementInvalid => e
          if e.message.include?("PG::DivisionByZero")
            return "0"
          else
            raise e
          end
        end
      end
    end

    def bounce_rate
      Stats::BounceRatesQuery.call(params).with_comparison.average("bounce_rate")
    end

    def visit_duration
      Stats::AverageVisitDurationQuery.call(params).with_comparison
    end

    private

    def cached(*names)
      AhoyCaptain.cache.fetch("ahoy_captain:#{names.join(":")}:#{params.permit!.except("controller", "action").to_unsafe_h.map { |k,v| "#{k}-#{v}" }.join(":")}", expire_in: AhoyCaptain.config.cache[:ttl]) do
        yield
      end
    end
  end
end
