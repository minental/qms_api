class User < ApplicationRecord
  include DatabaseAuthenticatable

  has_many :sessions, dependent: :destroy

  def role
    type.demodulize.downcase
  end
end
