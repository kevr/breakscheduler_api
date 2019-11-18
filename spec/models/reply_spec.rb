require 'rails_helper'

RSpec.describe Reply, type: :model do
  context 'Ticket reply model' do

    before do
      @user = User.create!({
        name: "Example User",
        email: "user@example.org",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })

      @ticket = Ticket.create!({
        user_id: @user.id,
        subject: "Some Ticket",
        body: "Intro text!",
      })
    end

    it 'can be created' do
      @reply = Reply.create!({
        ticket_id: @ticket.id,
        body: "A sweet reply!"
      })
    end

    it 'can be updated' do
      @reply = Reply.create!({
        ticket_id: @ticket.id,
        body: "A sweet reply!"
      })

      @reply.update(body: "An updated reply!")
    end

    it 'can be deleted via ticket being deleted' do
      Reply.create!({
        ticket_id: @ticket.id,
        body: "A reply that should be deleted when it's ticket is."
      })

      ticket_id = @ticket.id
      @ticket.destroy

      # We expect all replies that belong to this ticket_id
      # to be destroyed since @ticket.destroy was called
      replies = Reply.where(ticket_id: ticket_id)
      expect(replies.length).to eq 0
    end

  end
end
