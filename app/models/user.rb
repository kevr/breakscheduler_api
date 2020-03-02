class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def as_json(options = {})
    {
      "id" => self.id,
      "name" => self.name,
      "email" => self.email,
      "registered" => self.id != nil,
      "reset_password_token" => self.reset_password_token,
      "type" => self.id != nil ? "user" : "guest"
    }
  end
end
