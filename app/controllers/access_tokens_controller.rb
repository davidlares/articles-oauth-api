class AccessTokensController < ApplicationController

  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
  def create
    # using the authenticator object
    authenticator = UserAuthenticator.new(params[:code])
    # begin
      authenticator.perform
    # instead of breaking execution - the content of the rescue it returns
    # rescue UserAuthenticator::AuthenticationError
    #   authentication_error
    # end

    # using the authenticator object - generate an created status
    render json: authenticator.access_token, status: :created

  end

  private
  # private method
  def authentication_error
    error = {
      "status" => "401",
      "source" => {"pointer" => "/code"},
      "title" => "Authentication code is invalid",
      "detail" => "You must provide a valid code in order to exchange it for token."
    }
    render json: {"errors": [error]}, status: 401
  end
end
