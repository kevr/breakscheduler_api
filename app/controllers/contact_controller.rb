class ContactController < ApplicationController

  # This controller should _not_ exist. We are able to deduce if
  # an email is a user or guest, so this should be done in
  # TicketsController#create
  def create
    @admins = AdminUser.all
    @admins.each do |admin|
      SmtpMailer.contacted(
        user: admin,
        email: params[:email],
        subject: params[:subject],
        body: params[:body]
      ).deliver_later
    end
  end
end
