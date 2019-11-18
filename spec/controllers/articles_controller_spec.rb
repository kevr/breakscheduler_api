require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do

  context 'Article routes' do
    before do
      @article = Article.create!({
        title: "First Article",
        body: "Content for our first article!"
      })
    end

    it 'index returns full list of articles' do
      get :index
      expect(response.code).to eq '200'

      data = ActiveSupport::JSON.decode(response.body)
      expect(data.length).to eq 1

      article = data[0]
      expect(article['title']).to eq @article.title
      expect(article['body']).to eq @article.body
      expect(article['id']).to eq @article.id
      expect(@article.id).to eq 1
    end

    it 'show returns a single article' do
      get :show, params: {
        article_id: @article.id
      }
      expect(response.code).to eq '200'

      article = ActiveSupport::JSON.decode(response.body)
      expect(article['title']).to eq @article.title
      expect(article['body']).to eq @article.body
      expect(article['id']).to eq @article.id
      expect(@article.id).to eq 1
    end
  end
end
