# frozen_string_literal: true

module Mail
  def self.from_source(source)
    Mail.new Mail::Utilities.binary_unsafe_to_crlf(source.to_s)
  end

  # Extend Mail::Message to account for a Caffeinate::Mailing
  class Message
    attr_accessor :caffeinate_mailing

    def caffeinate_mailing=(mailing)
      @caffeinate_mailing = mailing
      if mailing.is_a?(::Caffeinate::Mailing)
        header['List-Unsubscribe'] = "<#{Caffeinate::UrlHelpers.caffeinate_subscribe_url(mailing.subscription)}>"
      end
    end

    def caffeinate?
      caffeinate_mailing.present?
    end
  end
end
