module AhoyCaptain
  class Current < ActiveSupport::CurrentAttributes
    attribute :request

    after_reset do
      self.request = nil
    end
  end
end
