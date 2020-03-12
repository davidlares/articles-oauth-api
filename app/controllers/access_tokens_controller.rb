class AccessTokensController < ApplicationController

  # calling method from application
  skip_before_action :authorize!, only: :create

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

  def destroy
    current_user.access_token.destroy
  end

end
