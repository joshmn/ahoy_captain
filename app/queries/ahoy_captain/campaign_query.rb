module AhoyCaptain
  class CampaignQuery < ApplicationQuery
    def build
      visit_query
        .select(
          "COALESCE(#{params[:campaigns_type]}, 'Direct/None') as label",
          "count(COALESCE(#{params[:campaigns_type]}, 'Direct/None')) as count",
          "sum(count(COALESCE(#{params[:campaigns_type]}, 'Direct/None'))) OVER() as total_count"
        )
        .group("COALESCE(#{params[:campaigns_type]}, 'Direct/None')")
        .order(Arel.sql("count(COALESCE(#{params[:campaigns_type]}, 'Direct/None')) desc"))
    end
  end
end
