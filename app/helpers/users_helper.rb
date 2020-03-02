module UsersHelper

  def user_exists(email)
    user = AdminUser.where(email: email)
    if not user.exists?
      user = User.where(email: email)
    end
    return user.exists?
  end

end
