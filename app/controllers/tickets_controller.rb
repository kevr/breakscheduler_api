class TicketsController < ApplicationController
  before_action :json_authenticated

  def index
    render json: @current_user.tickets
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
    if params[:subject]
      @ticket.update(subject: params[:subject])
    end
    if params[:body]
      @ticket.update(body: params[:body])
    end
    render json: @ticket
  end

  def show
    @ticket = Ticket.find(params[:id])
    render json: @ticket
  end
end
