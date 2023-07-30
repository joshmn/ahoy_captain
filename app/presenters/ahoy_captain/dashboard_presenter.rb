module AhoyCaptain
  class DashboardPresenter
    include RangeOptions

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def unique_visitors
      cached(:unique_visitors) do
        Stats::UniqueVisitorsQuery.call(params).count(:ip)
      end
    end

    def total_visits
      cached(:total_visits) do
        Stats::TotalVisitorsQuery.call(params).count
      end
    end

    def total_pageviews
      cached(:total_pageviews) do
        Stats::TotalPageviewsQuery.call(params).count
      end
    end

    def views_per_visit
      cached(:views_per_visit) do
        begin
          result = Stats::AverageViewsPerVisitQuery.call(params).count
          (result.values.sum.to_f / result.size).round(2)
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
      cached(:bounce_rate) do
        begin
        result = Stats::BounceRatesQuery.call(params)
        result[0].bounce_rate.round(2) / 10
        rescue ::ActiveRecord::StatementInvalid => e
        if e.message.include?("PG::DivisionByZero")
          return "0"
        else
          raise e
        end
      end

      end
    end

    def visit_duration
      cached(:visit_duration) do
        result = Stats::AverageVisitDurationQuery.call(params)
        duration = result[0].average_visit_duration
        if duration
          "#{duration.parts[:minutes]}M #{duration.parts[:seconds].round}S"
        else
          "0M 0S"
        end
      end
    end

    private

    def cached(*names)
      AhoyCaptain.cache.fetch("ahoy_captain:#{names.join(":")}:#{params.permit!.except("controller", "action").to_unsafe_h.map { |k,v| "#{k}-#{v}" }.join(":")}", expire_in: AhoyCaptain.config.cache.ttl) do
        yield
      end
    end
  end
end
