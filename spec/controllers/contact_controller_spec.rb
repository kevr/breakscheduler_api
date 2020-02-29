require 'rails_helper'

RSpec.describe ContactController, type: :controller do

  context 'ContactController' do
    before do
      @admin = AdminUser.create!({
        email: "admin@test.com",
        password: "abcd1234",
        password_confirmation: "abcd1234"
      })
    end

    it 'send a contact message' do
      post :create, params: {
        email: "random@person.com",
        subject: "Help Me Please!!",
        body: "Something very important"
      }
      expect(response.code).to eq '204'
    end
  end

end
