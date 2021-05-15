class Answer
  include ActiveModel::Model

  # quiz: Quizモデル
  # combinations: AnswerCombinationモデルのリスト
  attr_reader :quiz, :result, :combinations

  validates :quiz, presence: true
  validates :result, inclusion: { in: [true, false] }
  validates :combinations, presence: true

  # SQL
  SQL_COLUMS_GET = 'choices.id AS Choice_id, rhymes.content  AS rhyme_content'.freeze

  def initialize(quiz:, result:, combinations:)
    @quiz = quiz
    @result = result
    @combinations = combinations
  end

  class << self
    def get(quiz_id:, select_choice_ids:)
      quiz = Quiz.select(:id, :commentary).find(quiz_id)
      choices = quiz.choices.joins(:rhyme).select(SQL_COLUMS_GET)

      answer_combinations = get_answer_combinations(choices)

      Answer.new(quiz: quiz,
                 result: correct?(answer_combinations, select_choice_ids),
                 combinations: answer_combinations)
    end

    private

    def get_answer_combinations(choices)
      rhyme_contents = choices.map(&:rhyme_content).uniq
      answer_combinations = []

      rhyme_contents.each_with_index do |rhyme_content, idx|
        choice_ids = choices
                     .select { |choice| choice.rhyme_content == rhyme_content }
                     .map { |item| item.choice_id.to_s }
        answer_combinations[idx] = AnswerCombination.new(rhyme: rhyme_content, choice_ids: choice_ids)
      end
      answer_combinations
    end

    # answers:AnswerCombinationモデルのリスト
    def correct?(answer_combinations, select_choice_ids)
      answer_combinations.each do |answer_combination|
        return true if answer_combination.correct?(select_choice_ids)
      end
      false
    end
  end

  class AnswerCombination
    include ActiveModel::Model

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
end
