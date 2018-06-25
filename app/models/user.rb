class User < ApplicationRecord
  include DatabaseAuthenticatable

  has_many :sessions, dependent: :destroy
end
