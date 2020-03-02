require 'set'

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

  # Returns a boolean indicating whether or not the given email has
  # created the ticket or replied to the ticket
  def involves(params)
    if self.email == params[:email]
      return true
    end
    involvement = Reply.where(ticket: self, email: params[:email])
    return involvement.exists?
  end

  # Returns a list of all Ticket objects that involves the email
  def self.where_involves(params)
    tickets = Ticket.where(email: params[:email]).to_set
    replies = Reply.where(email: params[:email])
    replies.each do |reply|
      if not tickets.include?(reply.ticket)
        tickets.add(reply.ticket)
      end
    end
    return tickets.to_a
  end

  def is_user
    user = nil

    begin
      user = AdminUser.find(email: self.email)
    rescue ActiveRecord::RecordNotFound
      # Do nothing, user == nil
    end

    if user == nil
      begin
        user = User.find(email: self.email)
      rescue ActiveRecord::RecordNotFound
        # Do nothing, user == nil
      end
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
