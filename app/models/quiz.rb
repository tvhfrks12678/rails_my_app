class Quiz < ApplicationRecord
  belongs_to :user
  has_one :youtube, dependent: :destroy
  has_many :choices, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true

  scope :search_by, Queries::Quizzes::SearchByConditionsQuery

  SENTENCE_AFTER_TO_DISPLAY_IN_QUESTION  = '韻を踏んでいる組み合わせは？'.freeze
  SENTENCE_MIDLE_TO_DISPLAY_IN_QUESTION  = '付近から'.freeze

  def msg_to_display_in_question
    return SENTENCE_AFTER_TO_DISPLAY_IN_QUESTION if youtube.blank?

    "#{youtube.start_time_to_display_in_question}#{SENTENCE_MIDLE_TO_DISPLAY_IN_QUESTION}#{SENTENCE_AFTER_TO_DISPLAY_IN_QUESTION}"
  end
end
