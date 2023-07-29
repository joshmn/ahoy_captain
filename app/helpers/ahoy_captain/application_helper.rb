module AhoyCaptain
  module ApplicationHelper
    include Pagy::Frontend

    SPECIAL_PARAMS = [:campaigns_type, :devices_type]
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

    def render_pagination
      if @pagination
        pagy_nav(@pagination).html_safe
      else
        ""
      end
    end
  end
end
