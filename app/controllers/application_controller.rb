class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :setup_cors

  def setup_cors
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def json_authenticated
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
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    @decoded = JsonWebToken.decode(header)
    if not @decoded
      raise JWT::DecodeError.new "Unable to decode header"
    end
    @current_user = User.find(@decoded[:user_id])
  end
end
