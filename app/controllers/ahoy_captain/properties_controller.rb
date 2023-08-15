module AhoyCaptain
  class PropertiesController < ApplicationController
    before_action do
      @options = ::Ahoy::Event.select("jsonb_object_keys(properties) as keys").distinct("jsonb_object_keys(properties)").map(&:keys).map { |key| [Base64.urlsafe_encode64(key), key]}.to_h
    end

    def index
    end

    def show
      value = Base64.urlsafe_decode64(params[:id])

      @properties = event_query
        .select(
          "COALESCE(properties->>'#{value}', '(none)') AS label",
          "COUNT(*) AS events_count",
          "COUNT(DISTINCT visit_id) AS unique_visitors_count",
          "(COUNT(DISTINCT visit_id)/COUNT(*)::numeric) * 100 as percentage"
        )
        .group("COALESCE(properties->>'#{value}', '(none)')")
        .order(Arel.sql "COUNT(*) desc")
    end

    private

    helper_method :has_property?
    def has_property?(value)
      searching_properties[value]
    end

    helper_method :selected_property?
    def selected_property?(value)
      encoded = Base64.urlsafe_encode64(value, padding: false)
      encoded == params[:id]
    end

    def searching_properties
      JSON.parse(params.dig("q", "properties_json_cont") || '{}')
    end
  end
end
