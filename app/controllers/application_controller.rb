class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def json_authenticated
    if not _json_authenticated
      render json: {
        error: "A valid user session is required"
      }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: {
      error: e.message
    }, status: :unauthorized
  rescue JWT::DecodeError => e
    render json: {
      error: e.message
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
    @current_user = User.find(@decoded[:user_id]) if @decoded
  end
end
