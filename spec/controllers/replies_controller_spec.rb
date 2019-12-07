require 'rails_helper'

RSpec.describe RepliesController, type: :controller do

  describe 'RepliesController' do
    before do
      @user = User.create!({
        name: "Test User",
        email: "test@example.com",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })

      @ticket = Ticket.create!({
        user: @user,
        subject: "Test ticket",
        body: "Test content."
      })

      @token = JsonWebToken.encode(user_id: @user.id)
      headers = {
        "Authorization" => "Token #{@token}"
      }
      request.headers.merge! headers
    end

    it 'Reply create succeeds and shows' do
      post :create, params: {
        id: @ticket.id,
        body: "Test reply."
      }
      expect(response.code).to eq '200'
      reply = ActiveSupport::JSON.decode(response.body)

      get :show, params: {
        id: @ticket.id,
        reply_id: reply["id"]
      }
      expect(response.code).to eq '200'
      receivedReply = ActiveSupport::JSON.decode(response.body)

      expect(receivedReply).to eq reply
    end

    it 'Reply update succeeds' do
      post :create, params: {
        id: @ticket.id,
        body: "Test reply."
      }
      expect(response.code).to eq '200'
      reply = ActiveSupport::JSON.decode(response.body)

      patch :update, params: {
        id: @ticket.id,
        reply_id: reply["id"],
        body: "Modified body"
      }
      updatedReply = ActiveSupport::JSON.decode(response.body)

      expect(reply["body"]).to eq "Test reply."
      expect(updatedReply["body"]).to eq "Modified body"
    end

    it 'Reply delete succeeds' do
      post :create, params: {
        id: @ticket.id,
        body: "Test reply."
      }
      expect(response.code).to eq '200'
      reply = ActiveSupport::JSON.decode(response.body)

      delete :destroy, params: {
        id: @ticket.id,
        reply_id: reply["id"]
      }
      expect(response.code).to eq '204'
     end

    it 'show as a normal user requires the user owns the ticket' do
      @admin = AdminUser.create!({
        email: "test-admin@example.com",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })

      @reply = Reply.create!({
        ticket: @ticket,
        user: @user,
        body: "A reply"
      })

      # Authorized as user
      get :show, params: {
        id: @ticket.id,
        reply_id: @reply.id
      }
      expect(response.code).to eq '200'

      @adminTicket = Ticket.create!({
        user: @admin,
        subject: "Admin ticket",
        body: "Body"
      })

      @adminReply = Reply.create!({
        user: @admin,
        body: "Reply",
        ticket: @adminTicket
      })

      # Still authorized as user
      get :show, params: {
        id: @adminTicket.id,
        reply_id: @adminReply.id
      }
      expect(response.code).to eq '404'

      token = JsonWebToken.encode(admin_id: @admin.id)
      headers = {
        "Authorization" => "Token #{token}"
      }
      request.headers.merge! headers

      # Authorized as admin
      get :show, params: {
        id: @adminTicket.id,
        reply_id: @adminReply.id
      }
      expect(response.code).to eq '200'
    end
  end
end
