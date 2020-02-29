class SmtpMailer < ApplicationMailer
  def contact_email(params)
    @user = params[:user]
    @message = {
      email: params[:email],
      subject: params[:subject],
      body: params[:body]
    }
    @current_date = Date.new
    mail(to: @user.email, subject: "Contact Notification: #{params[:subject]}")
  end

end
