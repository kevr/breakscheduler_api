class RepliesController < ApplicationController
  before_action :json_authenticated

  def create
    @ticket = Ticket.find(params[:id])
    @reply = Reply.create!({
      body: params[:body],
      ticket: @ticket,
      email: @current_user.email
    })
    render json: @reply
  end

  def show
    @ticket = Ticket.find(params[:id])

    if @ticket.email != @current_user.email and @current_type != "admin"
      render json: {}, status: :not_found
      return
    end

    @reply = @ticket.replies.find(params[:reply_id])
    render json: @reply
  end

  def update
    @ticket = Ticket.where(email: @current_user.email, id: params[:id]).first
    @reply = @ticket.replies.find(params[:reply_id])
    @reply.update(body: params[:body])
    render json: @reply
  end

  def destroy
    @ticket = Ticket.where(email: @current_user.email, id: params[:id]).first
    @reply = @ticket.replies.find(params[:reply_id])
    @reply.delete
  end
end
