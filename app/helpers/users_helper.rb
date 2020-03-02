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

  def user_type(user)
    if user.instance_of?(AdminUser)
      return "admin"
    elsif user.instance_of?(GuestUser)
      return "guest"
    elsif user.instance_of?(User)
      return "user"
    end
    return nil
  end

  def authenticate_user(request, params)
    # Set these to null; this function will set it back to it's
    # value in the event that the request is coming from a valid
    # user.
    user = nil

    if params[:key]
      # First, see if the given Authorization value is a Ticket key
      begin
        ticket = Ticket.where(key: params[:key]).first
        logger.info "Matched ticket key: #{ticket.key}"
        user = GuestUser.new(email: ticket.email)
      rescue
        user = nil
      end
    end

    if user == nil
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      decoded = JsonWebToken.decode(header)
      if not user and not decoded
        raise JWT::DecodeError.new "Unable to decode header"
      end
    end

    # If it isn't, see if it's a User
    if user == nil
      begin
        user = User.find(decoded[:user_id])
      rescue
        user = nil
      end
    end

    # Otherwise, see if it's an AdminUser. If we actually look to see
    # if it's an admin and it's not, RecordNotFound will be raised signaling
    # that @current_user ended up null
    if user == nil
      user = AdminUser.find(decoded[:admin_id])
    end

    return user
  end

end
