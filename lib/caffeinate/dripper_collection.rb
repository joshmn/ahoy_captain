# frozen_string_literal: true

module Caffeinate
  class DripperCollection
    def initialize
      @registry = {}
    end

    def register(name, klass)
      @registry[name.to_sym] = klass
    end

    def resolve(campaign)
      @registry[campaign.slug.to_sym].constantize
    end
  end
end
