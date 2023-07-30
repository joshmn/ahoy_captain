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
  config.goal :appointment_created do
    label "Appointment Created"
    event "$appointment.created"
  end

  config.goal :appointment_updated do
    label "Appointment Updated"
    event "$appointment.updated"
  end

  config.funnel :appointments do
    label "Appointments"
    goal :appointment_created
    goal :appointment_updated
  end
end
