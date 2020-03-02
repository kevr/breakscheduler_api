require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  context 'user api sessions' do

    before do
      @user = User.create!({
        name: "Test User",
        email: "test@example.org",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })
    end

    it 'create a user via post' do
      post :new, params: {
        name: "Test User",
        email: "test2@example.org",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      }
      expect(response.code).to eq '200'
    end

    it 'cannot create a user with same email' do
      post :new, params: {
        name: "Test User",
        email: "test@example.org",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      }
      expect(response.code).to eq '400'

      data = ActiveSupport::JSON.decode(response.body)
      expect(data['error']).to eq "Email has already been taken"
    end

    it 'cannot create a user with a weak password' do
      post :new, params: {
        name: "Test User",
        email: "test2@example.org",
        password: "abc",
        password_confirmation: "abc"
      }
      expect(response.code).to eq '400'

      data = ActiveSupport::JSON.decode(response.body)
      expect(data['error']).to eq "Password is too short (minimum is 6 characters)"
    end

    it 'invalid password produces 401' do
      post :login, params: {
        email: "test@example.org",
        password: "blahblah"
      }
      expect(response.code).to eq '401'
    end

    it 'invalid email produces 404' do
      post :login, params: {
        email: "blah@blah.com",
        password: "blahblah"
      }
      expect(response.code).to eq '404'
    end

    it 'obtain an authentication token' do
      post :login, params: {
        email: "test@example.org",
        password: "abcd1234"
      }
      expect(response.code).to eq '200'

      data = ActiveSupport::JSON.decode(response.body)
      expect(data['token']).not_to eq nil
    end

    it 'cannot register when authenticated' do
      token = JsonWebToken.encode(user_id: @user.id)
      headers = {
        'Authorization' => "Token #{token}"
      }
      request.headers.merge! headers

      post :new, params: {
        name: "Test User",
        email: "test2@example.org",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      }
      expect(response.code).to eq '401'
    end

    it 'cannot login when authenticated' do
      token = JsonWebToken.encode(user_id: @user.id)
      headers = {
        'Authorization' => "Token #{token}"
      }
      request.headers.merge! headers

      post :login, params: {
        email: "test@example.org",
        password: "abcd1234"
      }
      expect(response.code).to eq '401'
    end

    it 'fetch api session user info with an api token' do
      token = JsonWebToken.encode(user_id: @user.id)
      headers = {
        'Authorization' => "Token #{token}"
      }
      request.headers.merge! headers
      get :info
      expect(response.code).to eq '200'

      data = ActiveSupport::JSON.decode(response.body)
      expected = {
        'id' => @user.id,
        'name' => @user.name,
        'email' => @user.email,
        'registered' => true,
        'reset_password_token' => nil,
        'type' => 'user'
      }
      expect(data).to eq expected
    end

    it 'invalid token used to fetch user info returns unauthorized' do
      headers = {
        'Authorization' => "Token blah"
      }
      request.headers.merge! headers
      get :info
      expect(response.code).to eq '401'
    end

    it 'trying to authorize as deleted user raises RecordNotFound' do
      token = JsonWebToken.encode(user_id: @user.id)
      headers = {
        'Authorization' => "Token #{token}"
      }
      request.headers.merge! headers
      
      @user.delete
      get :info
      expect(response.code).to eq '401'
    end
 
    it 'logging in as admin user returns token' do
      @admin = AdminUser.create!({
        email: "admin@example.org",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })

      post :admin_login, params: {
        email: "admin@example.org",
        password: "abcd1234"
      }
      expect(response.code).to eq '200'
    end

    it 'invalid password returns unauthorized' do
      @admin = AdminUser.create!({
        email: "admin@example.org",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })

      post :admin_login, params: {
        email: "admin@example.org",
        password: "xxx"
      }
      expect(response.code).to eq '401'
    end

    it 'invalid email returns 404' do
      post :admin_login, params: {
        email: "admin@example.org",
        password: "xxx"
      }
      expect(response.code).to eq '404'
    end

    it 'fetch api admin session info with an api token' do
      @admin = AdminUser.create!({
        email: "admin@example.org",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })

      token = JsonWebToken.encode(admin_id: @admin.id)
      headers = {
        'Authorization' => "Token #{token}"
      }
      request.headers.merge! headers

      get :info
      expect(response.code).to eq '200'

      data = ActiveSupport::JSON.decode(response.body)
      expected = {
        'id' => @admin.id,
        'name' => '',
        'email' => @admin.email,
        'reset_password_token' => nil,
        'registered' => true,
        'type' => 'admin'
      }
      expect(data).to eq expected
    end

    it 'can update myself as a user' do
      token = JsonWebToken.encode(user_id: @user.id)
      headers = {
        'Authorization' => "Token #{token}"
      }
      request.headers.merge! headers

      patch :update, params: {
        name: "Changed Name",
        email: "changed@example.com"
      }
      expect(response.code).to eq '200'
      
      data = ActiveSupport::JSON.decode(response.body);
      expect(data["name"]).to eq "Changed Name"
      expect(data["email"]).to eq "changed@example.com"
      expect(data["type"]).to eq "user"
  
      patch :update, params: {
        password: "haha1234",
        password_confirmation: "haha1234"
      }
      expect(response.code).to eq '200'

      @user = User.find(@user.id)
      expect(@user.email).to eq "changed@example.com"

      # Kill Authorization header and login with the new email
      # and password combination.
      request.headers["Authorization"] = nil
      post :login, params: {
        email: @user.email,
        password: "haha1234"
      }
      expect(response.code).to eq '200'
    end

    it 'can update own user details as admin' do
      @admin = AdminUser.create!({
        name: "Admin User",
        email: "admin@example.com",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })
      token = JsonWebToken.encode(admin_id: @admin.id)
      request.headers["Authorization"] = "Token #{token}"

      patch :update, params: {
        name: "Changed Name",
        email: "changed@example.com"
      }
      expect(response.code).to eq '200'
      
      data = ActiveSupport::JSON.decode(response.body);
      expect(data["name"]).to eq "Changed Name"
      expect(data["email"]).to eq "changed@example.com"
      expect(data["type"]).to eq "admin"
  
      patch :update, params: {
        password: "haha1234",
        password_confirmation: "haha1234"
      }
      expect(response.code).to eq '200'

      @admin = AdminUser.find(@admin.id)
      expect(@admin.email).to eq "changed@example.com"

      # Kill Authorization header and login with the new email
      # and password combination.
      request.headers["Authorization"] = nil
      post :admin_login, params: {
        email: @admin.email,
        password: "haha1234"
      }
      expect(response.code).to eq '200'
    end
  end
end
