class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  def as_json(options = {})
    {
      id: self.id,
      name: self.name,
      email: self.email,
      reset_password_token: self.reset_password_token,
      registered: self.id != nil,
      type: "admin"
    }
  end
end
