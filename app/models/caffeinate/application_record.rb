# frozen_string_literal: true

module Caffeinate
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
