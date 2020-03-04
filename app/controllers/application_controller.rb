class ApplicationController < ActionController::Base
  include UsersHelper

  skip_before_action :verify_authenticity_token
  before_action :probe_headers

  def probe_headers
    @http_origin = request.headers['Origin']
  end

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
    logger.debug "_json_authenticated encountered RecordNotFound"
    render json: {
      error: "Invalid authorization token"
    }, status: :unauthorized
  rescue JWT::DecodeError => e
    logger.debug "_json_authenticated encountered DecodeError"
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
    @current_user = authenticate_user(request, params)
    @current_type = user_type(@current_user)
    logger.debug "_json_authenticated resolved user type: #{@current_type}"
    return @current_user
  end
end
