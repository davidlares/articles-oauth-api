class AccessToken < ApplicationRecord
  belongs_to :user
  # after initialization object
  after_initialize :generate_token

  private
  def generate_token
    # include loop
    loop do
      break if token.present? && AccessToken.exists?(token: token)
      self.token = SecureRandom.hex(10)
    end
  end
end
