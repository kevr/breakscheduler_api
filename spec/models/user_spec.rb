require 'rails_helper'

RSpec.describe User, type: :model do
  context 'user management' do

    before do
      @user = User.create!({
        name: "Test User",
        email: "test@example.org",
        password: "test1234",
        password_confirmation: "test1234"
      })
    end

    it 'create a user' do
      expect(@user.name).to eq "Test User"
    end

    it 'creating a duplicate user raises error' do
      expect {
        User.create!({
          name: "Test User",
          email: "test@example.org",
          password: "test1234",
          password_confirmation: "test1234"
        })
      }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'authentication against created user' do
      # Test authentication
      expect(@user.valid_password?("test1234")).to eq true
      expect(@user.valid_password?("blah")).to eq false
    end

    it 'cannot create a user with an admin user email' do
      admin = AdminUser.create!({
        email: "admin@user.com",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })

      expect {
        User.create!({
          email: "admin@user.com",
          password: "abcd1234",
          password_confirmation: "abcd1234"
        })
      }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'cannot create an admin user with a user email' do
      expect {
        AdminUser.create!({
          email: "test@example.org",
          password: "abcd1234",
          password_confirmation: "abcd1234"
        })
      }.to raise_error ActiveRecord::RecordInvalid
    end

  end
end
