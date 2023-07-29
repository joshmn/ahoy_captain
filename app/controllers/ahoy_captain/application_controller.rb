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
      Current.request = self
    end

    # show the details frame
    before_action do
      if request.headers['Turbo-Frame'] == 'details'
        request.variant = :details
      end
    end

    # act like an spa without being an spa
    before_action do
      if request.format.html? && !request.referer.present?
        if request.path != root_path
          requested_params = Rails.application.routes.recognize_path(request.path).except(:controller, :action)
          params.merge!(requested_params)
          unless params[:debug]
            render template: 'ahoy_captain/roots/show'
          end
        end
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
