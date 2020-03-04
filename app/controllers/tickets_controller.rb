require 'set'

class TicketsController < ApplicationController
  include UsersHelper

  before_action :probe_auth, only: [ :create ]
  before_action :enforce_auth, except: [ :create ]

  def index
    @tickets = Ticket.where_involves(email: @current_user.email)
    render json: @tickets
  end

  def create
    if not @current_user.nil?
      if params[:email].nil?
        params[:email] = @current_user.email
      end
    end

    authenticated = user_exists(params[:email])

    # If the :email param belongs to a registered user
    if authenticated
      # If user is currently logged in and the user's email differs from
      # what we were given, or the request is coming from an unknown
      # visitor, return unauthorized
      if @current_user.nil? or
          (@current_user and @current_user.email != params[:email])
        render json: {
          error: "That email is reserved for a registered account."
        }, status: :unauthorized
        return
      end
    end

    @ticket = Ticket.create!({
      email: params[:email],
      subject: params[:subject],
      body: params[:body]
    })

    # If the ticket was created for a guest email, send our contacted
    # email notification to the guest user.
    if is_guest_email(params[:email])
      SmtpMailer.contacted(
        email: @ticket.email
      ).deliver_later
    end

    SmtpMailer.ticket_created(
      email: @ticket.email,
      ticket: @ticket,
      referrer: @http_origin
    ).deliver_later

    render json: @ticket
  end

  def update
    @ticket = Ticket.find(params[:id])
    is_admin = @current_type == "admin"
    if not is_admin and @ticket.email != @current_user.email
      render json: {
        error: "You are not authorized to modify this ticket."
      }, status: :unauthorized
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

    # If the viewer is not an admin and the ticket does not involve them,
    # or the current user is an authenticated guest and the id mismatches
    # the ticket id, return unauthorized.
    if (not is_admin and not @ticket.involves(email: @current_user.email)) or
        (is_guest(@current_user) and @current_user.id != @ticket.id)
      render json: {
        error: "You do not have authorization to view this ticket."
      }, status: :unauthorized
      return
    end

    render json: @ticket
  end
end
