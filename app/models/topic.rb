class Topic < ApplicationRecord

  def as_json(options = {})
    {
      id: self.id,
      subject: self.subject,
      body: self.body
    }
  end
end
