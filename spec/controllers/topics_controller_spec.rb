require 'rails_helper'

RSpec.describe TopicsController, type: :controller do

  context 'topic routes' do

    before do
      @topic = Topic.create!({
        subject: "Test",
        body: "Topic"
      })
    end

    it 'index lists all topics' do
      get :index
      expect(response.code).to eq '200'

      data = ActiveSupport::JSON.decode(response.body)
      expect(data.length).to eq 1

      topic = data[0]
      expect(topic['id']).to eq @topic.id
      expect(topic['subject']).to eq @topic.subject
      expect(topic['body']).to eq @topic.body
    end

    it 'shows a single topic' do
      get :show, params: {
        topic_id: @topic.id
      }
      expect(response.code).to eq '200'

      topic = ActiveSupport::JSON.decode(response.body)
      expect(topic['id']).to eq @topic.id
      expect(topic['subject']).to eq @topic.subject
      expect(topic['body']).to eq @topic.body
    end

    it 'matching search terms returns our record' do
      get :search, params: {
        terms: "Test"
      }
      expect(response.code).to eq '200'

      data = ActiveSupport::JSON.decode(response.body)
      expect(data.length).to eq 1

      topic = data[0]
      expect(topic['id']).to eq @topic.id
      expect(topic['subject']).to eq @topic.subject
      expect(topic['body']).to eq @topic.body
    end

    it 'matching body search terms returns our record' do
      get :search, params: {
        terms: "Topic"
      }
      expect(response.code).to eq '200'

      data = ActiveSupport::JSON.decode(response.body)
      expect(data.length).to eq 1

      topic = data[0]
      expect(topic['id']).to eq @topic.id
      expect(topic['subject']).to eq @topic.subject
      expect(topic['body']).to eq @topic.body
    end

    it 'unmatched search terms returns empty list' do
      get :search, params: {
        terms: "Blahblah"
      }
      expect(response.code).to eq '200'

      data = ActiveSupport::JSON.decode(response.body)
      expect(data.length).to eq 0
    end

  end

end
