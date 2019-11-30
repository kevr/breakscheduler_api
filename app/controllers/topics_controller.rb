class TopicsController < ApplicationController
  include TopicsHelper

  def index
    @topics ||= Topic.all
    render json: @topics
  end

  def show
    @topic ||= Topic.find(params[:topic_id])
    render json: @topic
  end

  def search
    terms = []

    # Split by spaces _or_ quoted substrings
    raw = params[:terms].split(/\s(?=(?:[^"]|"[^"]*")*$)/)
    raw.each do |t|
      terms.push(t.gsub('"', ''))
    end

    results = []
    terms.each do |term|
      # For each term, find all Topics with similar
      # subjects or bodies.
      topics = TopicSearch.new(filters: {
        term: term
      })

      # Combine results and uniqify them. Afterward,
      # push our new results onto our results list
      results += topics.results.uniq
    end

    topics = results.uniq
    render json: topics, only: [
      :id,
      :subject,
      :body
    ]
  end
end
