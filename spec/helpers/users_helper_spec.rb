require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, type: :helper do

  context 'method' do
  
    it 'is_admin works' do
      admin = AdminUser.create!({
        email: "test@example.com",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })
      expect(is_admin(admin)).to eq true
      expect(is_admin_email(admin.email)).to eq true

      # Throw these in to cover our negative is_guest cases
      expect(is_guest(admin)).to eq false
      expect(is_guest_email(admin.email)).to eq false
    end

    it 'is_admin_email fails successfully' do
      expect(is_admin_email("blah")).to eq false
    end

    it 'is_guest works' do
      user = GuestUser.new(email: "guest@example.com")
      expect(is_guest(user)).to eq true
    end

    it 'is_guest_email fails successfully' do
      expect(is_guest_email("blah@example.com")).to eq true
    end

    it 'user_exists works' do
      admin = AdminUser.create!({
        email: "test@example.com",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })
      expect(user_exists(admin.email)).to eq true
    end

    it 'user_object works' do
      admin = AdminUser.create!({
        email: "test@example.com",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })
      user = user_object(admin.email)
      expect(user.instance_of? AdminUser).to eq true
    end

    it 'user_type works' do
      user = User.new
      expect(user_type(user)).to eq "user"

      admin = AdminUser.new
      expect(user_type(admin)).to eq "admin"

      guest = GuestUser.new(email: "some@guest.com")
      expect(user_type(guest)).to eq "guest"
    end

  end

end
