class TicketsController < ApplicationController
  before_action :json_authenticated

  def index
    @tickets = Ticket.where(email: @current_user.email)
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
    if @ticket.email != @current_user.email and @current_type != "admin"
      render json: {}, status: :not_found
      return
    end

    if params[:subject]
      @ticket.update(subject: params[:subject])
    end
    if params[:body]
      @ticket.update(body: params[:body])
    end
    if params[:status]
      @ticket.update(status: params[:status])
    end
    render json: @ticket
  end

  def show
    @ticket = Ticket.find(params[:id])
    if @current_type == "user" and @ticket.email != @current_user.email
      render json: {}, status: :not_found
      return
    end

    render json: @ticket
  end
end
