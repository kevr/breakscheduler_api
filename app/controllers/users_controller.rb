class UsersController < ApplicationController
  before_action :json_not_authenticated, except: :info
  before_action :json_authenticated, only: :info

  def new
    begin
      @user = User.create!({
        name: params[:name],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      })
      render json: @user, only: [
        :id, :name, :email, :reset_password_token
      ], status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: {
        # Remove 'Validation failed: ' text from the beginning
        # of the exception message in this rescue
        error: e.message.gsub('Validation failed: ', '')
      }, status: :bad_request
    end
  end

  # User login action. This action 
  def login
    begin
      @user = User.find_by_email!(params[:email])
      if @user.valid_password?(params[:password])
        token = JsonWebToken.encode(user_id: @user.id)
        render json: {
          token: token
        }, status: :ok
      else
        render json: {
          error: "Invalid credentials"
        }, status: :unauthorized
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: {
        error: e.message
      }, status: :not_found
    end
  end

  # /users/me
  def info
    render json: @current_user, only: [
      :id, :name, :email, :reset_password_token
    ]
  end

end
