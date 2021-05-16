class AnswerCombination
  include ActiveModel::Model

  attr_reader :rhyme, :choice_ids

  validates :rhyme, presence: true
  validates :choice_ids, presence: true

  def initialize(rhyme:, choice_ids:)
    @rhyme = rhyme
    @choice_ids = choice_ids
  end

  def correct?(select_choice_ids)
    (@choice_ids - select_choice_ids).empty?
  end
end
