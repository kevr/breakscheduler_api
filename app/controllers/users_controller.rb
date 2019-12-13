class UsersController < ApplicationController
  before_action :json_not_authenticated, except: [ :info, :update ]
  before_action :json_authenticated, only: [ :info, :update ]

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

  # API User Login
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

  # API Administrator Login
  def admin_login
    begin
      @user = AdminUser.find_by_email!(params[:email])
      if @user.valid_password?(params[:password])
        token = JsonWebToken.encode(admin_id: @user.id)
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
    render json: @current_user
  end

  def update
    if params[:name]
      @current_user.update!(name: params[:name])
    end

    if params[:email]
      @current_user.update!(email: params[:email])
    end

    if params[:password] and params[:password_confirmation]
      if params[:password] === params[:password_confirmation]
        @current_user.password = params[:password]
        @current_user.save!
      end
    end

    render json: @current_user
  end

end
