class Quiz < ApplicationRecord
  belongs_to :user
  has_many :choices, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
end
