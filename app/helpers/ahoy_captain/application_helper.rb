module AhoyCaptain
  module ApplicationHelper
    include Pagy::Frontend

    # params that are coerced from the ApplicationController#act_like_an_spa
    SPECIAL_PARAMS = [:campaigns_type, :devices_type]

    def stats_container(value, url, label, formatter, selected = false)
      if value.is_a?(AhoyCaptain::ComparableQuery::Comparison)
        ::AhoyCaptain::Stats::ComparableContainerComponent.new(url, label, value, formatter, selected, compare_mode?)
      else
        ::AhoyCaptain::Stats::ContainerComponent.new(url, label, value, formatter, selected)
      end
    end

    def number_to_duration(duration)
      if duration
        "#{duration.in_minutes.to_i}M #{duration.parts[:seconds].to_i}S"
      else
        "0M 0S"
      end
    end
    def ahoy_captain_importmap_tags(entry_point = "application", shim: true)
      safe_join [
        (javascript_importmap_shim_tag if shim),
        (javascript_importmap_shim_nonce_configuration_tag if shim),
        javascript_import_module_tag(entry_point),
        javascript_importmap_module_preload_tags(AhoyCaptain.importmap),
        javascript_inline_importmap_tag(AhoyCaptain.importmap.to_json(resolver: self)),
      ].compact, "\n"
    end

    def search_params
      request.query_parameters
    end

    def special_params
      params.to_unsafe_h.slice(*SPECIAL_PARAMS)
    end

    # gets put into the form as a hidden field
    #
    def non_filter_ransack_params
      other_params = {}
      map = [
        :start_date,
        :end_date,
        :period,
        :interval,
        :comparison
      ]

      ransack = [:goal]

      map.each do |key|
        if params[key]
          other_params[key] = params[key]
        end
      end

      ransack.each do |key|
        Ransack.predicates.keys.each do |predicate|
          if value = params.dig(:q, "#{key}_#{predicate}")
            other_params[:q] ||= {}
            other_params[:q]["#{key}_#{predicate}"] = value
          end
        end
      end

      other_params
    end

    def render_pagination
      if @pagination
        pagy_nav(@pagination).html_safe
      else
        ""
      end
    end
  end
end
