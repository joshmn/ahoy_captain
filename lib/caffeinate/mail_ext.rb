# frozen_string_literal: true

module Mail
  def self.from_source(source)
    Mail.new Mail::Utilities.binary_unsafe_to_crlf(source.to_s)
  end

  # Extend Mail::Message to account for a Caffeinate::Mailing
  class Message
    attr_accessor :caffeinate_mailing

    def caffeinate?
      caffeinate_mailing.present?
    end
  end
end
