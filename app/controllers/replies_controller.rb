class RepliesController < ApplicationController
  before_action :json_authenticated

  def create
    @ticket = Ticket.find(params[:id])
    @reply = Reply.create!({
      body: params[:body],
      ticket: @ticket,
      user: @current_user
    })
    render json: @reply
  end

  def show
    @ticket = Ticket.find(params[:id])
    @reply = @ticket.replies.find(params[:reply_id])
    render json: @reply
  end

  def update
    @ticket = Ticket.find(params[:id])
    @reply = @ticket.replies.find(params[:reply_id])
    @reply.update(body: params[:body])
    render json: @reply
  end
end
