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

  end

end
