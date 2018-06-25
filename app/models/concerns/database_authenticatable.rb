module DatabaseAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_save :downcase_email

    validates :email, presence:true, email: true
    validates :password, length: { minimum: 6 }, allow_nil: true

    has_secure_password
  end

  private

  def downcase_email
    email.downcase!
  end
end
