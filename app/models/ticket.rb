class Ticket < ApplicationRecord
  belongs_to :user, polymorphic: true
  has_many :replies, dependent: :delete_all

  enum status: [
    :open,      # 0
    :escalated, # 1
    :closed     # 2
  ]

  def as_json(options = {})
    {
      "id" => self.id,
      "subject" => self.subject,
      "body" => self.body,
      "user" => self.user.as_json,
      "replies" => self.replies.order(:created_at).as_json,
      "status" => self.status,
      "updated_at" => self.updated_at
    }
  end
end
