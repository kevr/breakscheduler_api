class Reply < ApplicationRecord
  belongs_to :ticket
  belongs_to :user, polymorphic: true

  def as_json(options = {})
    {
      "id" => self.id,
      "body" => self.body,
      "user" => self.user.as_json,
      "updated_at" => self.updated_at
    }
  end

end
