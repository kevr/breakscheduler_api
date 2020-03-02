require 'set'

class TicketsController < ApplicationController
  before_action :json_authenticated

  def index
    @tickets = Ticket.where_involves(email: @current_user.email)
    render json: @tickets
  end

  def create
    @ticket = Ticket.create!({
      email: params[:email],
      subject: params[:subject],
      body: params[:body]
    })
    render json: @ticket
  end

  def update
    @ticket = Ticket.find(params[:id])
    is_admin = @current_type == "admin"
    if not is_admin and @ticket.email != @current_user.email
      render json: {}, status: :not_found
      return
    end

    if params[:subject]
      @ticket.update!(subject: params[:subject])
    end
    if params[:body]
      @ticket.update!(body: params[:body])
    end
    if params[:status]
      @ticket.update!(status: params[:status])
    end

    render json: @ticket
  end

  def show
    @ticket = Ticket.find(params[:id])
    is_admin = @current_type == "admin"
    # If the user viewing this is not an admin _and_ the ticket
    # does not involve the user's current email, then reply with 404
    if not is_admin and not @ticket.involves(email: @current_user.email)
      render json: {}, status: :not_found
      return
    end

    render json: @ticket
  end
end
