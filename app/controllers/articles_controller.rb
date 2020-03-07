class ArticlesController < ApplicationController
  # index method
  def index
    # selecting articles
    articles = Article.all
    render json: articles
  end
  # show method
  def show
  end
end
