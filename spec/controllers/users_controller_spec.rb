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
        'name' => nil,
        'email' => @admin.email,
        'reset_password_token' => nil,
        'type' => 'admin'
      }
      expect(data).to eq expected
    end

  end
end
