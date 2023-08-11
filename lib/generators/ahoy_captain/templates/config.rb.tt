AhoyCaptain.configure do |config|
  # ==> Event tracking
  #
  # View name
  # The event you use to dictate if a page view occurred
  # config.event.view_name = "$view"
  #
  # URL column
  # The properties that indicate what URL was viewed. Ahoy suggested tracking the
  # controller and action for each view by default, so we use that here.
  # config.event.url_column = "CONCAT(properties->>'controller', '#', properties->>'action')"
  #
  # If you have a `url` key in your `properties`, you could:
  # config.event.url_column = "properties->>'url'"
  #
  # URL exists
  # A query that indicates if a view event has the correct properties for a page view.
  # config.event.url_exists = "JSONB_EXISTS(properties, 'controller') AND JSONB_EXISTS(properties, 'action')"
  #
  # ==> Models
  #
  # Ahoy::Event model
  # config.models.event = '::Ahoy::Event'
  #
  # Ahoy::Visit model
  # config.models.visit = '::Ahoy::Visit'
  #
  #
  # ==> Theme
  #
  # https://daisyui.com/docs/themes/
  # config.theme = "dark"

  # ==> Disabled widgets
  # Some widgets are more expensive than others. You can disable them here.
  #
  # Here's the list of widgets:
  #   * sources
  #   * campaigns.utm_medium
  #   * campaigns.utm_source
  #   * campaigns.utm_term
  #   * campaigns.utm_content
  #   * campaigns.utm_campaign
  #   * top_pages
  #   * entry_pages
  #   * landing_pages
  #   * locations.countries
  #   * locations.regions
  #   * locations.cities
  #   * devices.browsers
  #   * devices.operating_systems
  #   * devices.device_types
  #
  # config.disabled_widgets = []

  # ==> Time periods
  #
  # Defaults come from lib/ahoy_captain/period_collection.rb
  #
  # If you want your own entirely, first call reset.
  # config.ranges.reset
  #
  # Then you can add your own.
  # config.ranges.add :param_name, "Label", -> { [3.days.ago, Date.today] }
  #
  # You can also remove an existing one:
  # config.ranges.delete(:mtd)
  #
  # Or add to the defaults:
  # config.ranges.add :custom, "Custom", -> { [6.hours.ago, 2.minutes.ago] }
  #
  # Or overwrite the defaults:
  # config.ranges.add :mtd, "Custom MTD", -> { [2.weeks.ago, Time.current] }
  #
  # And handle the default range, which will be used if no range is given:
  # config.ranges.default = '3d'
  #
  # The max range if a custom range is sent
  # config.ranges.max = 180.days
  #
  # Set to false to disable custom ranges
  # config.ranges.custom = true
  #
  # For an interval to be considered "realtime" it must not have a secondary item in the range

  # ==> Filters
  #
  # Defaults come from lib/ahoy_captain/filter_configuration.rb
  #
  # If you want your own entirely, first call reset.
  # config.filters.reset
  #
  # Then you can add your own.
  #
  # config.filters.register "Group label" do
  #   filter label: "Some label", column: :column_name, url: :url_for_options, predicates: [:in, :not_in], multiple: true
  # end
  #
  # You can also remove an existing group:
  #
  # config.filters.delete("Group label")
  #
  # Remove a specific filter from a group:
  #
  # config.filters["Group label"].delete(:column_name)
  #
  # You can add to an existing group:
  #
  # config.filters["Group label"].filter label: "Some label", column: :column_name, url: :url_for_options, predicates: [:in, :not_in], multiple: true

  # ==> Caching
  # config.cache.enabled = false
  #
  # Cache store should be an ActiveSupport::Cache::Store instance
  # config.cache.store = Rails.cache
  #
  # TTL
  # config.cache.ttl = 1.minute

  #==> Goal tracking
  # Your mother told you to have goals. Track those goals.
  #
  # Basically:
  #
  #   config.goal :unique_id do
  #     label "Some label here"
  #     name "The event name you're tracking in your Ahoy::Event table"
  #   end
  #
  # Real-world example:
  #
  #   config.goal :appointment_paid do
  #     label "Appointment Paid"
  #     name "$appointment.paid"
  #   end
  #
  # You can also use queries:
  #
  #   config.goal :appointment_paid do
  #     label "Appointment Paid"
  #     query do
  #       ::Ahoy::Event.where(...)
  #     end
  #   end

  # ==> Funnels
  # Your mother definitely didn't tell you about conversation rate.
  # Except, you're here, so...
  #
  # Basically:
  #
  #   config.funnel :id do
  #     label "Some label"
  #     goal :goal_id_1
  #     goal :goal_id_2
  #   end
  #
  # Real-world example:
  #
  #   config.funnel :appointments do
  #     label "Appointment Workflow"
  #     goal :appointment_created
  #     goal :appointment_paid
  #   end
  #
  # => Realtime interval
  # config.realtime_interval = 30.seconds
  #
  # How frequently the page should refresh if the interval is realtime
end
