module AhoyCaptain
  module Limitable
    private

    def limit
      if request.variant.include?(:details)
        nil
      else
        if params[:limit]
          params[:limit].to_i
        else
          10
        end
      end
    end
  end
end
