class AccessTokensController < ApplicationController

  # calling method from application
  skip_before_action :authorize!, only: :create

  def create
    # using the authenticator object
    authenticator = UserAuthenticator.new(authentication_params)
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

  private

  def authentication_params
    params.permit(:code).to_h.symbolize_keys # standard ruby hash
  end

  def standard_auth_params
    params.dig(:data, :attributes)&.permit(:login, :password)
  end

end
