module AhoyCaptain
  module Rangeable
    include AhoyCaptain::RangeOptions

    def period
      params[:period] || AhoyCaptain.config.ranges.default
    end

  end
end
