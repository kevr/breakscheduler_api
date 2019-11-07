require 'rails_helper'

RSpec.describe Member, type: :model do
  context 'member model' do

    before do
      @member = Member.create!({
        name: "Some Member",
        title: "Ingenious Engineer",
        email: "some@member.com",
        summary: "An awesome member."
      })
    end

    it 'creates a member' do
      expect(@member.name).to eq "Some Member"
      expect(@member.title).to eq "Ingenious Engineer"
      expect(@member.email).to eq "some@member.com"
      expect(@member.summary).to eq "An awesome member."
    end

  end
end
