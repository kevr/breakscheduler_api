class User < ApplicationRecord
  has_many :tickets

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def as_json(options = {})
    {
      id: self.id,
      name: self.name,
      email: self.email,
      reset_password_token: self.reset_password_token,
      type: "user"
    }
  end
end
