class NotARealDripper < Caffeinate::Dripper::Base
  default mailer_class: "CoolMailer"

  drip :test, delay: 0
end
