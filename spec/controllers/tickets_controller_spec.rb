require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  describe 'TicketsController' do
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
        body: "Content of the test ticket."
      })

      @token = JsonWebToken.encode(user_id: @user.id)
    end

    it 'unauthorized replies with 401' do
      get :index
      expect(response.code).to eq '401'
    end

    it 'authorized tickets index returns our tickets' do
      headers = {
        "Authorization" => "Token #{@token}"
      }
      request.headers.merge! headers

      get :index
      expect(response.code).to eq '200'

      data = ActiveSupport::JSON.decode(response.body)
      ticket = data[0]
      expect(ticket["user"]).to eq @user.as_json
      expect(ticket["subject"]).to eq "Test ticket"
      expect(ticket["body"]).to eq "Content of the test ticket."
    end

    it 'authorized tickets show returns the ticket' do
      headers = {
        "Authorization" => "Token #{@token}"
      }
      request.headers.merge! headers

      get :show, params: {
        id: @ticket.id
      }
      expect(response.code).to eq '200'

      ticket = ActiveSupport::JSON.decode(response.body)
      expect(ticket["user"]).to eq @user.as_json
      expect(ticket["subject"]).to eq "Test ticket"
      expect(ticket["body"]).to eq "Content of the test ticket."
    end

    it 'authorized tickets patch updates the ticket' do
      headers = {
        "Authorization" => "Token #{@token}"
      }
      request.headers.merge! headers

      get :update, params: {
        id: @ticket.id,
        subject: "Updated Subject",
        body: "Updated body."
      }
      expect(response.code).to eq '200'

      ticket = ActiveSupport::JSON.decode(response.body)
      expect(ticket["user"]).to eq @user.as_json
      expect(ticket["subject"]).to eq "Updated Subject"
      expect(ticket["body"]).to eq "Updated body."

    end

    it 'create a new ticket' do
      headers = {
        "Authorization" => "Token #{@token}"
      }
      request.headers.merge! headers

      post :create, params: {
        subject: "A New Ticket",
        body: "Man, oh man."
      }
      expect(response.code).to eq '200'
    end

    it 'show/update a ticket as someone unauthorized returns 404' do
      @otherUser = User.create!({
        name: "Other User",
        email: "other@user.com",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })

      @otherTicket = Ticket.create!({
        user: @otherUser,
        subject: "subject",
        body: "body"
      })

      headers = {
        "Authorization" => "Token #{@token}"
      }
      request.headers.merge! headers

      get :show, params: {
        id: @otherTicket.id
      }
      expect(response.code).to eq '404'

      patch :update, params: {
        id: @otherTicket.id,
        body: "modified"
      }
      expect(response.code).to eq '404'
    end 

  end
end
