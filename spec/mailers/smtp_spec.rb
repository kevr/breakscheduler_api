require "rails_helper"

RSpec.describe SmtpMailer, type: :mailer do

  context 'SmtpMailer' do
    before do
      @admin = AdminUser.create!({
        email: "admin@test.com",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })
    end

    it 'contact_email works' do
      SmtpMailer.contact_email(
        user: @admin,
        email: "test@example.com",
        subject: "Test Subject",
        body: "Test Body"
      ).deliver_now
    end

  end

end
