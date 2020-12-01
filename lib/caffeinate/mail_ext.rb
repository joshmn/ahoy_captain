# frozen_string_literal: true

module Mail
  # Extend Mail::Message to account for a Caffeinate::Mailing
  class Message
    attr_accessor :caffeinate_mailing

    def caffeinate?
      caffeinate_mailing.present?
    end
  end
end
