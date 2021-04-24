class Quiz < ApplicationRecord
  belongs_to :user
  has_many :quiz_choice, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :commentary, length: { maximum: 255 }
end
