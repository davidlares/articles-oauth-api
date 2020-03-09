class AccessToken < ApplicationRecord
  belongs_to :user
  # after initialization object
  after_initialize :generate_token

  private
  def generate_token
    # include loop
    loop do
      # there's a validation for not to look if token exists for user with certain ID
      break if token.present? && !AccessToken.where.not(id: id).exists?(token: token)
      self.token = SecureRandom.hex(10)
    end
  end
end
