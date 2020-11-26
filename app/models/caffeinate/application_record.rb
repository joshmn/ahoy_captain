# frozen_string_literal: true

module Caffeinate
  # :nodoc:
  class ApplicationRecord < ::ActiveRecord::Base
    self.abstract_class = true
  end
end
