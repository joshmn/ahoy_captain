module AhoyCaptain
  module Stats
    class BaseQuery < ApplicationQuery

      private
      def compare?
        params[:compare] != 'false'
      end

      def comparison_params
        comp_params = params.dup.except(:period, :start_date, :end_date)

        diff = (range[1] - range[0]).seconds
        comp_params[:start_date] = (range[0] - diff.in_seconds).to_datetime
        comp_params[:end_date] = (range[1] - diff.in_seconds).to_datetime
        comp_params
      end
    end
  end
end
