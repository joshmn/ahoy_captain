# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :company, optional: true
end
