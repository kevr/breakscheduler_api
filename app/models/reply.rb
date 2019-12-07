class Reply < ApplicationRecord
  belongs_to :ticket
  belongs_to :user, polymorphic: true

  # JSON Serialization for Reply.
  def as_json(options = {})
    {
      "id" => self.id,
      "body" => self.body,
      "user" => self.user.as_json,
      "updated_at" => self.updated_at,
      "ticket_id" => self.ticket_id
    }
  end
end
