class Ticket < ApplicationRecord
  belongs_to :user

  enum status: [
    :open,      # 0
    :escalated, # 1
    :closed     # 2
  ]
end
