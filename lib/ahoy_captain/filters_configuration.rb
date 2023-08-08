require 'ahoy_captain/filter_configuration/filter'
require 'ahoy_captain/filter_configuration/filter_collection'

module AhoyCaptain
  class FiltersConfiguration
    def self.load_default
      new.tap do |config|
        config.register("Page") do
          filter column: :route, label: "Route", url: :filters_actions_path, predicates: [:in, :not_in]
          filter column: :entry_page, label: "Entry Page", url: :filters_entry_pages_path, predicates: [:in, :not_in]
          filter column: :exit_page, label: "Exit Page", url: :filters_exit_pages_path, predicates: [:in, :not_in]
        end

        config.register("Geography") do
          filter column: :country, label: "Country", url: :filters_locations_countries_path, predicates: [:in, :not_in]
          filter column: :region, label: "Region", url: :filters_locations_regions_path, predicates: [:in, :not_in]
          filter column: :city, label: "City", url: :filters_locations_cities_path, predicates: [:in, :not_in]
        end

        config.register("Source") do
          filter column: :referring_domain, label: "Source", url: :filters_sources_path, predicates: [:in, :not_in]
        end

        config.register("Screen size") do
          filter column: :device_type, label: "Screen size", url: :filters_screens_path, predicates: [:in, :not_in]
        end

        config.register("Operating System") do
          filter column: :os, label: "OS Name", url: :filters_names_path, predicates: [:in, :not_in]
          filter column: :os_version, label: "OS Version", url: :filters_versions_path, predicates: [:in, :not_in]
        end

        config.register("UTM Tag") do
          filter column: :utm_medium, label: "UTM Medium", url: :filters_utm_mediums_path, predicates: [:in, :not_in]
          filter column: :utm_source, label: "UTM Source", url: :filters_utm_sources_path, predicates: [:in, :not_in]
          filter column: :utm_campaign, label: "UTM Campaign", url: :filters_utm_campaigns_path, predicates: [:in, :not_in]
          filter column: :utm_term, label: "UTM Term", url: :filters_utm_terms_path, predicates: [:in, :not_in]
          filter column: :utm_content, label: "UTM Content", url: :filters_utm_contents_path, predicates: [:in, :not_in]
        end
      end
    end

    def initialize
      @registry = {}
    end

    def register(label, &block)
      item = FilterConfiguration::FilterCollection.new(label)
      item.instance_exec(&block)
      @registry[label] = item
    end

    def [](val)
      @registry[val]
    end

    def delete(name)
      @registry.delete(name)
    end

    def reset
      @registry = {}
    end

    def each(&block)
      @registry.each(&block)
    end
  end
end
