class Reply < ApplicationRecord
  belongs_to :ticket

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

  # JSON Serialization for Reply.
  def as_json(options = {})
    {
      "id" => self.id,
      "body" => self.body,
      "email" => self.email,
      "registered" => self.is_user,
      "updated_at" => self.updated_at,
      "ticket_id" => self.ticket_id
    }
  end
end
