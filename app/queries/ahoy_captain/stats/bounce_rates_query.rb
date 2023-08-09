module AhoyCaptain
  module Stats
    class BounceRatesQuery < BaseQuery
      def build
        total_visits = visit_query.select("date(#{AhoyCaptain.visit.table_name}.started_at) as date, count(*) as count").group("date(#{AhoyCaptain.visit.table_name}.started_at)")
        subquery = visit_query.select(:id, :started_at).joins(:events).group("#{AhoyCaptain.visit.table_name}.id, #{AhoyCaptain.visit.table_name}.started_at").having("count(#{AhoyCaptain.event.table_name}.id) = 1")
        single_page_visits = ::Ahoy::Visit.select("date(subquery.started_at) as date, count(*) as count").from("(#{subquery.to_sql}) as subquery").group("date(started_at)")
        daily_bounce_rate = ::Ahoy::Visit.select("total_visits.date, (single_page_visits.count::FLOAT / total_visits.count) * 100 as bounce_rate")
                                         .from("total_visits")
                                         .joins("join single_page_visits ON total_visits.date = single_page_visits.date")

        ::Ahoy::Visit.with(total_visits: total_visits, single_page_visits: single_page_visits, daily_bounce_rate: daily_bounce_rate).select("bounce_rate, date").from("daily_bounce_rate")
      end

      protected

      def self.cast_type(column)
        ActiveRecord::Type.lookup(:decimal)
      end

      def self.cast_value(type, value)
        super.round(2)
      end

    end
  end
end
