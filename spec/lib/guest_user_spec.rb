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
RSpec.describe GuestUser do

  context 'valid input' do

    it 'creates an instance and returns proper json' do
      user = GuestUser.new(email: "test@example.com")
      expect(user.email).to eq "test@example.com"

      data = user.as_json
      expect(data["id"]).to eq nil
      expect(data["name"]).to eq ''
      expect(data["email"]).to eq "test@example.com"
      expect(data["registered"]).to eq false
    end

    it 'creates an instance with a specific name' do
      user = GuestUser.new(email: "test@example.com", name: "NAME!")
      expect(user.email).to eq "test@example.com"
      expect(user.name).to eq "NAME!"
    end

  end

  context 'invalid input' do
    it 'raises an exception when no email is given' do
      expect {
        user = GuestUser.new
      }.to raise_error ActiveRecord::StatementInvalid
    end
  end

end
