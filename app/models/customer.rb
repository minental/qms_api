class Customer < ApplicationRecord
  has_one :serving, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true

  scope :in_queue, -> { left_outer_joins(:serving).where(servings: { id: nil }).order(:id) }

  mount_uploaders :attachments, AttachmentUploader
end
