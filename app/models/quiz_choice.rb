class QuizChoice < ApplicationRecord
  belongs_to :quiz
  validates :quiz_id, presence: true
  validates :content, presence: true, length: { maximum: 30 }
end
