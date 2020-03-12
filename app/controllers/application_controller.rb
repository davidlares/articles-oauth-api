class ApplicationController < ActionController::API
  class AuthorizationError < StandardError; end

  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
  rescue_from AuthorizationError, with: :authorization_error

  # allow everything here - restrict in each controller
  before_action :authorize!

  # private method
  private

  def authorize!
    raise AuthorizationError unless current_user
  end

  def access_token
    # this brings the Bearer filtering by regex, then & is for validating and returning NIL
    provided_token = request.authorization&.gsub(/\ABearer\s/, '')
    @access_token = AccessToken.find_by(token: provided_token)
  end

  def current_user
    @current_user = access_token&.user # coming from front-end
  end

  def authentication_error
    error = {
      "status" => "401",
      "source" => { "pointer" => "/code" },
      "title" => "Authentication code is invalid",
      "detail" => "You must provide a valid code in order to exchange it for token."
    }
    render json: {"errors": [error]}, status: 401
  end

  def authorization_error
    error = {
      "status" => "403",
      "source" => { "pointer" => "/headers/authorization" },
      "title" =>  "Not authorized",
      "detail" => "You have no right to access this resource."
    }
    render json: {"errors": error}, status: 403
  end

end
