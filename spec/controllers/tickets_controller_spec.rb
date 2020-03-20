require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  include UsersHelper
  include JsonHelper

  context 'CRUD' do

    before do
      @admin = AdminUser.create!({
        email: "admin@example.com",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })

      @user = User.create!({
        name: "Test User",
        email: "test@example.com",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })

      @admin_token = JsonWebToken.encode(admin_id: @admin.id)
      @user_token = JsonWebToken.encode(user_id: @user.id)
    end

    it 'unauthorized index replies with 401' do
      get :index
      expect(response.code).to eq '401'
    end

    it 'authorized index replies with all tickets involved in' do
      ticket = Ticket.create!({
        email: @user.email,
        subject: "Test subject",
        body: "Test body"
      })

      other_ticket = Ticket.create!({
        email: "random@email.com",
        subject: "Other subject",
        body: "Other body"
      })

      Reply.create!({
        email: @user.email,
        ticket: other_ticket,
        body: "Reply body"
      })

      set_token(request, @user_token)
      get :index
      expect(response.code).to eq '200'

      data = decode(response.body)
      expect(data).to eq [
        get_json(ticket.as_json),
        get_json(other_ticket.as_json)
      ]
    end

    # admin ticket index returns all tickets
    it 'admin ticket index returns all tickets' do
      ticket = Ticket.create!({
        email: @user.email,
        subject: "Test subject",
        body: "Test body"
      })

      other_ticket = Ticket.create!({
        email: "random@email.com",
        subject: "Other subject",
        body: "Other body"
      })

      set_token(request, @admin_token)
      get :index
      expect(response.code).to eq '200'

      data = decode(response.body)
      expect(data.length).to eq 2
    end

    it 'ticket reply as other user involved generates email' do
    end

    it 'unauthorized show replies with 401' do
      get :show, params: {
        id: 1
      }
      expect(response.code).to eq '401'
    end

    it 'unauthorized update replies with 401' do
      patch :update, params: {
        id: 1,
        subject: "New Ticket Subject"
      }
      expect(response.code).to eq '401'
    end

    it 'authorized update works' do
      ticket = Ticket.create!({
        email: @user.email,
        subject: "Test subject",
        body: "Test body"
      })

      expect(ticket.subject).to eq "Test subject"

      set_token(request, @user_token)
      patch :update, params: {
        id: ticket.id,
        status: "closed",
        subject: "Modified subject",
        body: "Modified body"
      }
      expect(response.code).to eq '200'
      
      data = ActiveSupport::JSON.decode(response.body)
      expect(data["status"]).to eq "closed"
      expect(data["subject"]).to eq "Modified subject"
      expect(data["body"]).to eq "Modified body"
    end

    it 'authorized as a different user than creator rejects ticket update' do
      other_user = User.create!({
        name: "Other User",
        email: "other@user.com",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })

      ticket = Ticket.create!({
        email: other_user.email,
        subject: "Other subject",
        body: "Other body"
      })

      set_token(request, @user_token)
      patch :update, params: {
        id: ticket.id,
        subject: "Modified subject"
      }
      expect(response.code).to eq '401'
    end

    it 'authorized create allows omitting email parameter' do
      set_token(request, @user_token)
      post :create, params: {
        subject: "Test subject",
        body: "Test body"
      }
      expect(response.code).to eq '200'

      data = ActiveSupport::JSON.decode(response.body)
      expect(data["email"]).to eq @user.email
    end

    it 'authorized user gets 401 when trying to view an admin ticket' do
      @adminTicket = Ticket.create!({
        email: @admin.email,
        subject: "Admin ticket test",
        body: "Admin ticket body"
      })

      set_token(request, @user_token)
      get :show, params: {
        id: @adminTicket.id
      }
      expect(response.code).to eq '401'
    end

    it 'guest create replies with 401 when given email is registered' do
      # Attempt to create a ticket while unauthenticated with
      # a registered email
      post :create, params: {
        email: @user.email,
        subject: "Test subject",
        body: "Test body"
      }
      expect(response.code).to eq '401'
    end

    it 'authorized create replies with 200' do
      set_token(request, @user_token)
      post :create, params: {
        email: @user.email,
        subject: "Test subject",
        body: "Test body"
      }
      expect(response.code).to eq '200'
    end

    it 'authorized user can create a guest ticket' do
      set_token(request, @user_token)
      post :create, params: {
        email: "guest@example.com",
        subject: "Test subject",
        body: "Test body"
      }
      expect(response.code).to eq '200'
    end

    it 'invalid key parameter is bypassed' do
      ticket = Ticket.create!({
        email: "guest@user.com",
        subject: "Test subject",
        body: "Test body"
      })

      get :show, params: {
        id: ticket.id,
        key: "BLAH"
      }
      expect(response.code).to eq '401'
    end

    it 'valid key parameter is used to deduce guest' do
      ticket = Ticket.create!({
        email: "guest@user.com",
        subject: "Test subject",
        body: "Test body"
      })

      get :show, params: {
        id: ticket.id,
        key: ticket.key
      }
      expect(response.code).to eq '200'
    end

  end

end
