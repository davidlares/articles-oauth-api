class ArticlesController < ApplicationController

  skip_before_action :authorize!, only: [:index, :show]
  # index method
  def index
    # selecting articles
    articles = Article.recent.page(params[:page]).per(params[:per_page])
    render json: articles
  end
  # show method
  def show
  end
end
