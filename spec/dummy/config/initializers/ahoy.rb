class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false

Ransack.configure do |c|
  # Raise errors if a query contains an unknown predicate or attribute.
  # Default is true (do not raise error on unknown conditions).
  c.ignore_unknown_conditions = false
end

AhoyCaptain.configure do |config|
  config.ranges.delete :all
  config.goal :viewed_booking_form do
    label "Viewed booking form"
    query do
      ::Ahoy::Event.where("ahoy_events.properties @> ?", { controller: "booking/schedules", action: "show"}.to_json)
    end
  end

  config.goal :created_appointment do
    label "Appointment Updated"
    query do
      ::Ahoy::Event.where("ahoy_events.properties @> ?", { controller: "booking/appointments", action: "show"}.to_json)
    end
  end

  config.funnel :appointments do
    label "Appointments"
    goal :viewed_booking_form
    goal :created_appointment
  end

  config.ranges.max = 100.days
  config.disabled_widgets = ["top_pages"]
end
