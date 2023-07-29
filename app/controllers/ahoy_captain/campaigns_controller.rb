module AhoyCaptain
  class CampaignsController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:campaigns, params[:type])
        raise Widget::WidgetDisabled.new("Widget disabled", :sources)
      end
    end

    def index
      @campaigns = cached(:campaigns, params[:type]) do
        visit_query.within_range
                   .select(
                     "COALESCE(#{params[:type]}, 'Direct/None') as label",
                     "count(COALESCE(#{params[:type]}, 'Direct/None')) as count",
                     "sum(count(COALESCE(#{params[:type]}, 'Direct/None'))) OVER() as total_count"
                   )
                   .group("COALESCE(#{params[:type]}, 'Direct/None')")
                   .order(Arel.sql("count(COALESCE(#{params[:type]}, 'Direct/None')) desc"))
                   .limit(limit)
      end
                     .map { |campaign| CampaignDecorator.new(campaign) }
      @campaign_type = params[:type]&.titleize&.gsub("Utm", "UTM")

      render json: @campaigns
    end
  end
end
