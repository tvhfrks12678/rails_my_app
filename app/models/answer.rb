class Answer
  include ActiveModel::Model

  attr_reader :rhyme, :choice_ids

  validates :rhyme, presence: true
  validates :choice_ids, presence: true

  # SQL
  SQL_COLUMS_CHOICES = 'choices.id, rhymes.content as rhyme_content'.freeze

  def initialize(rhyme:, choice_ids:)
    @rhyme = rhyme
    @choice_ids = choice_ids
  end

  def correct?(select_choice_ids)
    (choice_ids - select_choice_ids).empty?
  end

  # answers:Answerモデルのリスト 
  def self.correct?(answers, select_choice_ids)
    answers.each do |answer|
      # return true if (answer.choice_ids - select_choice_ids).empty?
      return true if answer.correct?(select_choice_ids)
    end
    false
  end

  def self.get(quiz_id:)
    choices = Choice.joins(:rhyme).where(quiz_id: quiz_id).select(SQL_COLUMS_CHOICES)
    rhyme_contents = choices.map(&:rhyme_content).uniq
    answers = []

    rhyme_contents.each_with_index do |rhyme_content, idx|
      choice_choice_ids = choices
                          .select { |choice| choice.rhyme_content == rhyme_content }
                          .map { |item| item.id.to_s }
      answers[idx] = Answer.new(rhyme: rhyme_content, choice_ids: choice_choice_ids)
    end

    answers
  end
end
