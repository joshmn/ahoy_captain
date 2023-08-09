module AhoyCaptain
  class DashboardPresenter
    include RangeOptions

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def unique_visitors
      cached(:unique_visitors) do
        Stats::UniqueVisitorsQuery.call(params).count(:visitor_token)
      end
    end

    def total_visits
      cached(:total_visits) do
        Stats::TotalVisitorsQuery.call(params).count(:id)
      end
    end

    def total_pageviews
      cached(:total_pageviews) do
        Stats::TotalPageviewsQuery.call(params).count(:id)
      end
    end

    def views_per_visit
      cached(:views_per_visit) do
        begin
          result = Stats::ViewsPerVisitQuery.call(params).count(:id)
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
      cached(:bounce_rate) do
        begin
          result = Stats::BounceRatesQuery.call(params)
          average = result.average("bounce_rate")
          if average
            average.round(2)
          else
            "0"
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

    def visit_duration
      cached(:visit_duration) do
        result = Stats::AverageVisitDurationQuery.call(params)
        duration = result[0].average_visit_duration
        if duration
          "#{duration.in_minutes.to_i}M #{duration.parts[:seconds].to_i}S"
        else
          "0M 0S"
        end
      end
    end

    private

    def cached(*names)
      AhoyCaptain.cache.fetch("ahoy_captain:#{names.join(":")}:#{params.permit!.except("controller", "action").to_unsafe_h.map { |k,v| "#{k}-#{v}" }.join(":")}", expire_in: AhoyCaptain.config.cache[:ttl]) do
        yield
      end
    end
  end
end
