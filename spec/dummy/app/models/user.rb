class User < ApplicationRecord
  belongs_to :company, optional: true
end
