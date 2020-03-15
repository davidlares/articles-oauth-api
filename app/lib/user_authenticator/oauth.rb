class UserAuthenticator::Oauth < UserAuthenticator
  class AuthenticationError < StandardError; end # custom class inheritance

  attr_reader :user
  # handle the whole auth logic
  def initialize(code)
    # code (arg) - exchange for access token
    @code = code
  end

  def perform
      # raising custom error
      raise AuthenticationError if code.blank?
      raise AuthenticationError if token.try(:error).present?
      prepare_user
  end

  # private methods and attributes
  private

  def client
    @client ||= Octokit::Client.new(
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET']
    )
  end

  def token
    # communicating with Github - grabbing the token
    @token ||= client.exchange_code_for_token(code)
  rescue Octokit::NotFound
    raise AuthorizationError
  end

  def user_data
    # token (user/password) then grabbing data via (hashes) after successful connection
    @user_client ||= Octokit::Client.new(access_token: token).user.to_h.slice(:login, :avatar_url, :url, :name)
  end

  def prepare_user
    # find if exists
    @user = if User.exists?(login: user_data[:login])
      User.find_by(login: user_data[:login])
    else
      # creating users
      User.create(user_data.merge(provider: 'github'))
    end
  end

  attr_reader :code

end
