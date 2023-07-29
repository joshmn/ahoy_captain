module AhoyCaptain
  class UrlHelpers
    include AhoyCaptain::Engine.routes.url_helpers
    include Singleton
  end
end
