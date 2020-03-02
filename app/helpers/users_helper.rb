module UsersHelper

  def is_admin(user)
    return user.instance_of? AdminUser
  end

  def is_admin_email(email)
    user = user_object(email)
    if user != nil
      return user.instance_of? AdminUser
    end
    return false
  end

  def is_guest(user)
    return user.instance_of? GuestUser
  end

  def is_guest_email(email)
    return user_object(email) == nil
  end

  def user_object(email)
    user = AdminUser.where(email: email)
    if not user.exists?
      user = User.where(email: email)
    end
    return user.exists? == true ? user.first : nil
  end

  def user_exists(email)
    return user_object(email) != nil
  end

end
