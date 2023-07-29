AhoyCaptain.configure do
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
  # config.periods.reset
  #
  # Then you can add your own.
  # config.periods.add :param_name, "Label", -> { [3.days.ago, Date.today] }
  #
  # You can also remove an existing one:
  # config.periods.delete(:mtd)
  #
  # Or add to the defaults:
  # config.periods.add :custom, "Custom", -> { [6.hours.ago, 2.minutes.ago] }
  #
  # Or overwrite the defaults:
  # config.periods.add :mtd, "Custom MTD", -> { [2.weeks.ago, Time.current] }
  #
  # And handle the default range, which will be used if no range is given:
  # config.periods.default = '3d'

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
  #     event "The event name you're tracking in your Ahoy::Event table"
  #   end
  #
  # Real-world example:
  #
  #   config.goal :appointment_paid do
  #     label "Appointment Paid"
  #     event "$appointment.paid"
  #   end

  # ==> Funnels
  # Your mother definitely didn't tell you about conversation rate.
  # Except, you're here, so...
  #
  # Basically:
  #
  #   config.funnel "Label/Title" do
  #     goal :goal_id_1
  #     goal :goal_id_2
  #   end
  #
  # Real-world example:
  #
  #   config.funnel "Appointment Workflow" do
  #     goal :appointment_created
  #     goal :appointment_paid
  #   end
end
