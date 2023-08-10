module AhoyCaptain
  module Limitable
    private

    def limit
      if request.variant.include?(:details)
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

  module CompareMode
    def self.included(klass)
      if klass.is_a?(ActionController::Base)
        klass.helper_method :compare_mode?
      end
    end

    def compare_mode?
      params[:comparison] == 'true'
    end
  end

  class ApplicationController < ActionController::Base
    include Pagy::Backend

    include CompareMode

    layout 'ahoy_captain/layouts/application'

    # show the details frame
    before_action :use_details_frame

    # act like an spa without being an spa
    before_action :act_like_an_spa

    rescue_from Widget::WidgetDisabled do |e|
      render template: 'ahoy_captain/shared/widget_disabled', locals: { frame: e.frame }
    end

    private

    def use_details_frame
      if request.headers['Turbo-Frame'] == 'details'
        request.variant = :details
      end
    end

    def act_like_an_spa
      if request.format.html? && request.headers['Turbo-Frame'].blank?
        if request.path != root_path
          requested_params = Rails.application.routes.recognize_path(request.path).except(:controller, :action)
          params.merge!(requested_params)
          unless params[:debug]
            render template: 'ahoy_captain/roots/show'
          end
        end
      end
    end

    def visit_query
      VisitQuery.call(params)
    end

    def event_query
      EventQuery.call(params)
    end

    # Only paginate details requests requests
    def paginate(collection)
      if paginate?
        pagy, results = pagy(collection, page: params[:page])
        @pagination = pagy
        return results
      end

      collection
    end

    def paginate?
      request.variant.include?(:details)
    end

    def cached(*names)
      if AhoyCaptain.cache.class == ActiveSupport::Cache::NullStore
        return yield
      end
      AhoyCaptain.cache.fetch("ahoy_captain:#{names.join(":")}:#{request.query_parameters.sort.map { |k,v| "#{k}-#{v}" }.join(":")}", expire_in: AhoyCaptain.config.cache[:ttl]) do
        yield
      end
    end


  end
end
