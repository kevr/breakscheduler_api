require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  context 'members endpoints' do

    before do
      @member = Member.create!({
        name: "Some Member",
        title: "Ingenious Member",
        email: "some@member.com",
        summary: "An extraordinary member."
      })
    end

    it 'gets a specific member' do
      get :show, params: {
        member_id: @member.id
      }
      expect(response.code).to eq '200'
    end

    it 'gets all members' do
      get :index
      expect(response.code).to eq '200'
    end

  end
end
