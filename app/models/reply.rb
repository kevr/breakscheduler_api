class Reply < ApplicationRecord
  belongs_to :ticket

  # JSON Serialization for Reply.
  def as_json(options = {})
    {
      "id" => self.id,
      "body" => self.body,
      "email" => self.email,
      "updated_at" => self.updated_at,
      "ticket_id" => self.ticket_id
    }
  end
end
