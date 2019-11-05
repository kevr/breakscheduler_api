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

  end
end
