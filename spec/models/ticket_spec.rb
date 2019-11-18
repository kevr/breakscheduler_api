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
      @ticket = @user.tickets.create!({
        subject: "Ticket subject",
        body: "Ticket body"
      })

      expect(@user).to eq @ticket.user
      expect(@ticket.subject).to eq "Ticket subject"
      expect(@ticket.body).to eq "Ticket body"
      expect(@ticket.status).to eq "open"

      @ticket.status = "closed"
      @ticket.save
      expect(@ticket.status).to eq "closed"
    end

  end
end
