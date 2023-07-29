module AhoyCaptain
  module Rangeable
    include AhoyCaptain::RangeOptions

    def period
      params[:period]
    end

  end
end
