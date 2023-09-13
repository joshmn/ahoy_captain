module AhoyCaptain
  class ApplicationController < ActionController::Base
    include Pagy::Backend
    include CompareMode
    include RangeOptions
    include Rangeable

    around_action :use_ahoy_captain_locale

    layout 'ahoy_captain/layouts/application'

    def period
      params[:period] || AhoyCaptain.config.ranges.default
    end

    # show the details frame
    before_action :use_details_frame

    # act like an spa without being an spa
    before_action :act_like_an_spa

    rescue_from Widget::WidgetDisabled do |e|
      render template: 'ahoy_captain/shared/widget_disabled', locals: { frame: e.frame }
    end

    private

    def use_ahoy_captain_locale(&action)
      @original_i18n_config = I18n.config
      I18n.config = ::AhoyCaptain::I18nConfig.new
      I18n.with_locale(current_locale, &action)
    ensure
      I18n.config = @original_i18n_config
      @original_i18n_config = nil
    end

    def use_original_locale
      prev_config = I18n.config
      I18n.config = @original_i18n_config if @original_i18n_config
      yield
    ensure
      I18n.config = prev_config
    end

    def current_locale
      if request.GET['locale']
        request.GET['locale']
      elsif params[:locale]
        params[:locale]
      else
        I18n.default_locale
      end
    end

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
