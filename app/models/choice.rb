class Choice < ApplicationRecord
  belongs_to :quiz
  belongs_to :rhyme, optional: true
  validates :quiz_id, presence: true
  validates :content, presence: true
end
