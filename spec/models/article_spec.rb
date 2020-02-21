require 'rails_helper'

RSpec.describe Article, type: :model do
  context 'Article model' do

    it 'can be created without exception path' do
      @article = Article.create({
        subject: "An Article",
        body: "Some article content"
      })
      expect(@article.subject).to eq "An Article"
      expect(@article.body).to eq "Some article content"
      expect(@article.order).to eq 1
    end

    it 'can be created' do
      @article = Article.create!({
        subject: "An Article",
        body: "Some article content"
      })
      expect(@article.subject).to eq "An Article"
      expect(@article.body).to eq "Some article content"
      expect(@article.order).to eq 1
    end

    it 'bumps order value' do
      @article = Article.create!({
        subject: "An Article",
        body: "Some article content"
      })
      expect(@article.subject).to eq "An Article"
      expect(@article.body).to eq "Some article content"
      expect(@article.order).to eq 1

      new_article = Article.create!({
        subject: "Another Article",
        body: "Some more content!"
      })
      expect(new_article.order).to eq 2
    end

  end
end
