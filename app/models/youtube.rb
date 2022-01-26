class Youtube < ApplicationRecord
  belongs_to :quiz
  validates :quiz_id, presence: true

  SECONDS_PER_MINUTES = 60
  MINUTES_PER_HOUR = 60

  SENTENCE_AFTER_TO_DISPLAY_IN_QUESTION  = '韻を踏んでいる組み合わせは？'.freeze
  SENTENCE_MIDLE_TO_DISPLAY_IN_QUESTION  = '付近から'.freeze

  def url
    "https://www.youtube.com/embed/#{video_id}?start=#{start_time}"
  end

  def start_time_to_display_in_question
    return Time.at(start_time).strftime('%M:%S') if start_time < SECONDS_PER_MINUTES * MINUTES_PER_HOUR

    Time.at(start_time).strftime('%H:%M:%S')
  end
end
