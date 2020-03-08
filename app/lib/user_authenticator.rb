class UserAuthenticator
  class AuthenticationError < StandardError; end # custom class inheritance
  attr_reader :user
  # handle the whole auth logic
  def initialize(code)
    # code (arg) - exchange for access token
    @code = code
  end

  def perform
    client = Octokit::Client.new(
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET']
    )
    # communicating with Github - grabbing the token
    token = client.exchange_code_for_token(code)
    if token.try(:error).present?
      # raising custom error
      raise AuthenticationError
    else
      # token (user/password)
      user_client = Octokit::Client.new(access_token: token)
      # grabbing data via (hashes) after successful connection
      user_data = user_client.user.to_h.slice(:login, :avatar_url, :url, :name)
      # creating users
      User.create(user_data.merge(provider: 'github'))
    end
  end

  # private code
  private
  attr_reader :code

end
