require "rails_helper"

RSpec.describe SmtpMailer, type: :mailer do

  before do
    # Create a user to use where we need it
    @user = User.create!({
      email: "admin@test.com",
      password: "abcd1234",
      password_confirmation: "abcd1234"
    })
  end

  context 'contacted' do
    it 'works' do
      SmtpMailer.contacted(
        email: "test@example.com"
      ).deliver_now
    end
  end

  context 'ticket_created' do
    it 'ticket_created by User runs without issue' do
      ticket = Ticket.create!({
        email: @user.email,
        subject: "Test subject",
        body: "Test body"
      })

      mail = SmtpMailer.ticket_created(
        ticket: ticket,
        registered: true,
        referrer: "http://localhost:3000"
      ).deliver_now

      expect(
        mail.body.encoded.include?(
          "http://localhost:3000/help/support/tickets/#{ticket.id}"
        )
      ).to eq true
      expect(
        mail.body.encoded.include?(
          "http://localhost:3000/help/support/tickets/#{ticket.id}?key=#{ticket.key}"
        )
      ).to eq false
    end

    it 'ticket_created by guest runs without issue' do
      ticket = Ticket.create!({
        email: "guest@email.com",
        subject: "Guest subject",
        body: "Guest body"
      })

      mail = SmtpMailer.ticket_created(
        ticket: ticket,
        referrer: "http://localhost:3000"
      ).deliver_now

      expect(
        mail.body.encoded.include?(
          "http://localhost:3000/help/support/tickets/#{ticket.id}?key=#{ticket.key}"
        )
      ).to eq true
    end

    it 'ticket_created with no referrer raises ArgumentError' do
      ticket = Ticket.create!({
        email: "guest@email.com",
        subject: "Guest subject",
        body: "Guest body"
      })

      expect {
        SmtpMailer.ticket_created(
          ticket: ticket
        ).deliver_now
      }.to raise_error SmtpMailer::ArgumentError
    end

    it 'ticket_created with no ticket or bad ticket raises ArgumentError' do
      expect {
        SmtpMailer.ticket_created(
          referrer: "http://localhost:3000"
        ).deliver_now
      }.to raise_error SmtpMailer::ArgumentError

      expect {
        SmtpMailer.ticket_created(
          ticket: "blah blah",
          referrer: "http://localhost:3000"
        ).deliver_now
      }.to raise_error SmtpMailer::ArgumentError
    end
  end

  context 'reply_created' do
    before do
      @ticket = Ticket.create!({
        email: @user.email,
        subject: "Test subject",
        body: "Test body"
      })

      @reply = Reply.create!({
        ticket: @ticket,
        email: @user.email,
        body: "Reply body"
      })
    end
    
    it 'works' do
      mail = SmtpMailer.reply_created(
        email: @ticket.email,
        ticket: @ticket,
        reply: @reply,
        referrer: "http://localhost:3000"
      ).deliver_now
      expect(mail.subject).to eq "You've got a new reply!"
      expect(
        mail.body.encoded.include?(
          "http://localhost:3000/help/support/tickets/#{@ticket.id}"
        )
      ).to eq true
      expect(
        mail.body.encoded.include?(
          "http://localhost:3000/help/support/tickets/#{@ticket.id}?key=#{@ticket.key}"
        )
      ).to eq false
    end

    it 'with no email raises ArgumentError' do
      expect {
        SmtpMailer.reply_created(
          ticket: @ticket,
          reply: @reply,
          referrer: "http://localhost:3000"
        ).deliver_now
      }.to raise_error SmtpMailer::ArgumentError
    end

    it 'with no referrer raises ArgumentError' do
      expect {
        SmtpMailer.reply_created(
          email: @ticket.email,
          ticket: @ticket,
          reply: @reply
        ).deliver_now
      }.to raise_error SmtpMailer::ArgumentError
    end

    it 'with no ticket raises ArgumentError' do
      expect {
        SmtpMailer.reply_created(
          email: @ticket.email,
          reply: @reply,
          referrer: "http://localhost:3000"
        ).deliver_now
      }.to raise_error SmtpMailer::ArgumentError
    end

    it 'with invalid ticket raises ArgumentError' do
      expect {
        SmtpMailer.reply_created(
          email: @ticket.email,
          ticket: "blah blah",
          reply: @reply,
          referrer: "http://localhost:3000"
        ).deliver_now
      }.to raise_error SmtpMailer::ArgumentError
    end

    it 'with no reply raises ArgumentError' do
      expect {
        SmtpMailer.reply_created(
          email: @ticket.email,
          ticket: @ticket,
          referrer: "http://localhost:3000"
        ).deliver_now
      }.to raise_error SmtpMailer::ArgumentError
    end

    it 'with invalid reply raises ArgumentError' do
      expect {
        SmtpMailer.reply_created(
          email: @ticket.email,
          ticket: @ticket,
          reply: "blah blah",
          referrer: "http://localhost:3000"
        ).deliver_now
      }.to raise_error SmtpMailer::ArgumentError
    end

    it 'with an email that is not the owner produces different subject' do
      mail = SmtpMailer.reply_created(
        email: "guest@email.com",
        ticket: @ticket,
        reply: @reply,
        referrer: "http://localhost:3000"
      ).deliver_now
      expect(mail.subject).to eq "Your ticket has received a reply"
      expect(
        mail.body.encoded.include?(
          "http://localhost:3000/help/support/tickets/#{@ticket.id}?key=#{@ticket.key}"
        )
      ).to eq true
    end

  end

end
