require 'rails_helper'

RSpec.describe Topic, type: :model do
  context 'manage Topic objects' do

    it 'cannot create null subject objects' do
      expect {
        Topic.create!({
          body: "Blah"
        })
      }.to raise_error ActiveRecord::NotNullViolation
    end

    it 'cannot create null body objects' do
      expect {
        Topic.create!({
          subject: "Blah"
        })
      }.to raise_error ActiveRecord::NotNullViolation
    end

    it 'can create objects' do
      @topic = Topic.create!({
        subject: "Subject",
        body: "Body"
      })

      expect(@topic.id).not_to eq nil
      expect(@topic.subject).to eq "Subject"
      expect(@topic.body).to eq "Body"
    end

  end
end
