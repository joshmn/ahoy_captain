module AhoyCaptain
  module Rangeable
    def period
      params[:period] || AhoyCaptain.config.ranges.default
    end
  end
end
