class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  # Probe authorization keys provided. Populate @current_user if one was
  # found, otherwise leave it nil.
  def probe_auth
    _json_authenticated
  rescue
    nil
  end

  # Enforce authentication when used. If a user account cannot be found,
  # then we render :unauthorized to the api user.
  def enforce_auth
    _json_authenticated
  rescue ActiveRecord::RecordNotFound => e
    render json: {
      error: "Invalid authorization token"
    }, status: :unauthorized
  rescue JWT::DecodeError => e
    render json: {
      error: "Invalid authorization token"
    }, status: :unauthorized
  end

  def json_authenticated
    enforce_auth
  end

  def json_not_authenticated
    # If _json_authenticated returns nothing, a valid user
    # session has been decoded via JWT
    if _json_authenticated
      render json: {
        error: "You are already authenticated as a user"
      }, status: :unauthorized
    end
  rescue
    nil
  end

  def _json_authenticated
    # Set these to null; this function will set it back to it's
    # value in the event that the request is coming from a valid
    # user.
    @current_user = nil
    @current_type = nil

    if params[:key]
      # First, see if the given Authorization value is a Ticket key
      begin
        ticket = Ticket.where(key: params[:key]).first
        logger.info "Matched ticket key: #{ticket.key}"
        @current_user = GuestUser.new(email: ticket.email)
        @current_type = "guest"
      rescue
        @current_user = nil
      end     
    end

    if @current_user == nil
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      @decoded = JsonWebToken.decode(header)
      if not @current_user and not @decoded
        raise JWT::DecodeError.new "Unable to decode header"
      end
    end

    # If it isn't, see if it's a User
    if @current_user == nil
      begin
        @current_user = User.find(@decoded[:user_id])
        @current_type = "user"
      rescue
        @current_user = nil
      end
    end

    # Otherwise, see if it's an AdminUser. If we actually look to see
    # if it's an admin and it's not, RecordNotFound will be raised signaling
    # that @current_user ended up null
    if @current_user == nil
      @current_user = AdminUser.find(@decoded[:admin_id])
      @current_type = "admin"
    end

    @current_user
  end
end
