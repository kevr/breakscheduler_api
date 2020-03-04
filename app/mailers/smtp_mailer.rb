class SmtpMailer < ApplicationMailer
  add_template_helper(UsersHelper)

  class ArgumentError < StandardError
  end

  def contacted(params)
    @email = params[:email]
    mail(to: @email, subject: "Thank you for contacting us")
  end

  # An email notification for ticket creation.
  def ticket_created(params)
    @referrer = params[:referrer]
    if @referrer.nil?
      raise ArgumentError.new "Parameter 'referrer' required"
    end

    @ticket = params[:ticket]
    if @ticket.nil?
      raise ArgumentError.new "Parameter 'ticket' required"
    elsif not @ticket.instance_of?(Ticket)
      raise ArgumentError.new "Parameter 'ticket' must be a Ticket"
    end

    @email = @ticket.email
    @current_date = Date.new

    mail(to: @email, subject: "Ticket Created (\##{@ticket.id})")
  end

  # Reply notification
  def reply_created(params)
    @referrer = params[:referrer]
    if @referrer.nil?
      raise ArgumentError.new "Parameter 'referrer' required"
    end

    @ticket = params[:ticket]
    if @ticket.nil?
      raise ArgumentError.new "Parameter 'ticket' required"
    elsif not @ticket.instance_of?(Ticket)
      raise ArgumentError.new "Parameter 'ticket' must be a Ticket"
    end

    @reply = params[:reply]
    if @reply.nil?
      raise ArgumentError.new "Parameter 'reply' required"
    elsif not @reply.instance_of?(Reply)
      raise ArgumentError.new "Parameter 'reply' must be a Reply"
    end

    @email = params[:email]
    if @email.nil?
      raise ArgumentError.new "Parameter 'email' required"
    end

    subject = "You've got a new reply!"
    if @email != @ticket.email
      # In this case, the user is a guest
      subject = "Your ticket has received a reply"
    end

    mail(to: @email, subject: subject)
  end

end
