# An Article is used to store content related to
# guide articles. An Article should never be
# provided an order manually; an order will be
# alotted to each Article as they are created.
# They can be modified via our ActiveAdmin /admin
# interface.
#
class Article < ApplicationRecord
  # Each article can have nested articles.
  # article = Article.create
  # article.articles.create
  # article.articles.find
  validates :order, uniqueness: true

  def self.create(attributes = {}, &block)
    articles = Article.order(order: :asc)
    new_order = articles.last ? articles.last.order + 1 : 1
    attributes[:order] = new_order
    super
  end

  def self.create!(attributes = {}, &block)
    articles = Article.order(order: :asc)
    new_order = articles.last ? articles.last.order + 1 : 1
    attributes[:order] = new_order
    super
  end

  def as_json(options = {})
    {
      :id => self.id,
      :subject => self.subject,
      :body => self.body
    }
  end
end
