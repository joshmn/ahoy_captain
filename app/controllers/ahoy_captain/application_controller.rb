module AhoyCaptain
  module Limitable
    private

    def limit
      if request.variant == :details
        nil
      else
        if params[:limit]
          params[:limit].to_i
        else
          10
        end
      end
    end
  end

  class ApplicationController < ActionController::Base
    layout 'ahoy_captain/layouts/application'

    before_action do
      if request.headers['Turbo-Frame'] == 'details'
        request.variant = :details
      end
    end

    rescue_from Widget::WidgetDisabled do |e|
      render template: 'ahoy_captain/shared/widget_disabled', locals: { frame: e.frame }
    end

    private

    def visit_query
      VisitQuery.call(params)
    end

    def event_query
      EventQuery.call(params)
    end

    def cached(*names)
      AhoyCaptain.cache.fetch("ahoy_captain:#{names.join(":")}:#{request.query_parameters.sort.map { |k,v| "#{k}-#{v}" }.join(":")}", expire_in: AhoyCaptain.config.cache.ttl) do
        yield
      end
    end
  end
end
