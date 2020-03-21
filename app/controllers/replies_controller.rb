class RepliesController < ApplicationController
  before_action :json_authenticated

  def create
    @ticket = Ticket.find(params[:id])
    @reply = Reply.create!({
      body: params[:body],
      ticket: @ticket,
      email: @current_user.email
    })

    # Notify everybody involved in the ticket
    emails = @ticket.involved_emails
    emails.each do |email|
      if @reply.email != email
        SmtpMailer.reply_created(
          ticket: @ticket,
          reply: @reply,
          referrer: @http_origin,
          email: email
        ).deliver_later
      end
    end

    render json: @reply
  end

  def show
    @ticket = Ticket.find(params[:id])

    logger.info "ticket email: #{@ticket.email}"
    logger.info "current user email: #{@current_user.email}"

    if @ticket.email != @current_user.email and @current_type == "user"
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
