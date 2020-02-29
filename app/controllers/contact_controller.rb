class ContactController < ApplicationController
  def create
    @admins = AdminUser.all
    @admins.each do |admin|
      SmtpMailer.contact_email(
        user: admin,
        email: params[:email],
        subject: params[:subject],
        body: params[:body]
      ).deliver_later
    end
  end
end
