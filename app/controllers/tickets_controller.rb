class TicketsController < ApplicationController
  before_action :json_authenticated

  def index
    @tickets = Ticket.where(user: @current_user)
    render json: @tickets
  end

  def create
    @ticket = Ticket.create!({
      user: @current_user,
      subject: params[:subject],
      body: params[:body]
    })
    render json: @ticket
  end

  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.user != @current_user and @current_type != "admin"
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
    if @ticket.user != @current_user and @current_type != "admin"
      render json: {}, status: :not_found
      return
    end

    render json: @ticket
  end
end
