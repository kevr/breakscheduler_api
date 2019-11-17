require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TopicsHelper. For example:
#
# describe TopicsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TopicsHelper, type: :helper do
  context 'Topic search' do

    it 'search returns a single topic' do
      @topic = Topic.create!({
        subject: "Test",
        body: "My little topic"
      })

      topics = TopicsHelper::TopicSearch.new(term: "Test")
      expect(topics.count).to eq 1
    end

  end
end
