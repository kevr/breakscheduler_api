require 'rails_helper'

RSpec.describe Ticket, type: :model do
  context 'Ticket model' do

    before do
      @user = User.create!({
        name: "Some User",
        email: "user@example.org",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })
    end

    it 'can be created' do
      @ticket = Ticket.create!({
        email: @user.email,
        subject: "Ticket subject",
        body: "Ticket body"
      })

      expect(@ticket.email).to eq @user.email
      expect(@ticket.subject).to eq "Ticket subject"
      expect(@ticket.body).to eq "Ticket body"
      expect(@ticket.status).to eq "open"

      @ticket.status = "closed"
      @ticket.save
      expect(@ticket.status).to eq "closed"
    end

  end
end
