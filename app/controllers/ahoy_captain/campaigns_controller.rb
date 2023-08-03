module AhoyCaptain
  class CampaignsController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:campaigns, params[:campaigns_type])
        raise Widget::WidgetDisabled.new("Widget disabled", :sources)
      end
    end

    def index
      results = cached(:campaigns, params[:campaigns_type]) do
        visit_query
                   .select(
                     "COALESCE(#{params[:campaigns_type]}, 'Direct/None') as label",
                     "count(COALESCE(#{params[:campaigns_type]}, 'Direct/None')) as count",
                     "sum(count(COALESCE(#{params[:campaigns_type]}, 'Direct/None'))) OVER() as total_count"
                   )
                   .group("COALESCE(#{params[:campaigns_type]}, 'Direct/None')")
                   .order(Arel.sql("count(COALESCE(#{params[:campaigns_type]}, 'Direct/None')) desc"))
                   .limit(limit)
      end
      @campaigns = paginate(results).map { |campaign| CampaignDecorator.new(campaign, self) }
      @campaign_type = params[:campaigns_type]&.titleize&.gsub("Utm", "UTM")
    end
  end
end
