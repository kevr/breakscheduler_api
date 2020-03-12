class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum user_type: [
    :user,
    :staff
  ]

  validate :verify_unique_email

  def verify_unique_email
    if AdminUser.exists?(email: self.email)
      errors.add :email, "has already been taken"
    end
  end

  def as_json(options = {})
    {
      "id" => self.id,
      "name" => self.name,
      "email" => self.email,
      "registered" => self.id != nil,
      "reset_password_token" => self.reset_password_token,
      "type" => self.user_type
    }
  end
end
