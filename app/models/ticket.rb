class Ticket < ApplicationRecord
  has_many :replies, dependent: :delete_all

  enum status: [
    :open,      # 0
    :escalated, # 1
    :closed     # 2
  ]

  before_create :create_hook

  def create_hook
    if self.key == nil
      self.key = SecureRandom.uuid
    end
  end

  def is_user
    user = nil

    begin
      user = AdminUser.find(email: self.email)
    rescue ActiveRecord::RecordNotFound
      # Do nothing, user == nil
    end

    begin
      user = User.find(email: self.email)
    rescue ActiveRecord::RecordNotFound
      # Do nothing, user == nil
    end

    return user != nil
  end

  def as_json(options = {})
    {
      "id" => self.id,
      "subject" => self.subject,
      "body" => self.body,
      "email" => self.email,
      "registered" => self.is_user,
      "replies" => self.replies.order(:created_at).as_json,
      "status" => self.status,
      "updated_at" => self.updated_at
    }
  end
end
