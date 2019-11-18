class Ticket < ApplicationRecord
  belongs_to :user
  has_many :replies, dependent: :delete_all

  enum status: [
    :open,      # 0
    :escalated, # 1
    :closed     # 2
  ]
end
