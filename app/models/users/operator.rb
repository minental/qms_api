class Users::Operator < User
  has_many :servings, dependent: :destroy

  def active_serving
    servings.active.last
  end
end
