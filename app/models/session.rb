class Session < ApplicationRecord
  TIMEOUT = Rails.application.config.session_timeout

  belongs_to :user

  validates :access_token, presence: true

  before_create :set_access_token

  scope :expired,           -> { where('updated_at < ?', Time.current - TIMEOUT) }
  scope :not_expired,       -> { where('updated_at > ?', Time.current - TIMEOUT) }

  private

  def set_access_token
    self.access_token = SecureRandom.urlsafe_base64
  end
end
