class Serving < ApplicationRecord
  belongs_to :operator, class_name: 'Users::Operator', foreign_key: :operator_id
  belongs_to :customer

  enum status: [:active, :closed, :no_show]
end
