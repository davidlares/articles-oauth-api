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
    render json: Article.find(params[:id])
  end

  def create
    # logic
    article = current_user.articles.build(article_params)
    article.save!
      render json: article, status: :created
  rescue
      # returning data with serializer error (custom) and the JSON standard
      render json: article, adapter: :json_api,
        serializer: ErrorSerializer,
        status: :unprocessable_entity
  end

  def update
    # find by parameters
    article = current_user.articles.find(params[:id])
    article.update_attributes!(article_params)
    render json: article, status: :ok
  rescue ActiveRecord::RecordNotFound
    authorization_error
  rescue
    render json: article, adapter: :json_api,
      serializer: ErrorSerializer,
      status: :unprocessable_entity
  end

  def destroy
    # finding article
    article = current_user.articles.find(params[:id])
    article.destroy
    head :no_content
  rescue
    authorization_error
  end

  private
  def article_params
    # params required mandatory with certain "attributes" key with values
    params.require(:data).require(:attributes).permit(:title, :content, :slug) || ActionController::Parameters.new
  end
end
