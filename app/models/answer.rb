class Answer
  include ActiveModel::Model

  attr_reader :quiz, :is_correct, :combinations

  validates :quiz, presence: true
  validates :is_correct, inclusion: { in: [true, false] }
  validates :combinations, presence: true

  # SQL
  SQL_COLUMS_GET = 'choices.id AS Choice_id, rhymes.content  AS rhyme_content'.freeze

  # @param [Quiz] quiz
  # @param [Boolean] is_correct
  # @param [Array<AnswerCombination>] combinations
  def initialize(quiz:, is_correct:, combinations:)
    @quiz = quiz
    @is_correct = is_correct
    @combinations = combinations
  end

  class << self
    # 回答表示に関する情報を取得する

    # @param [String] quiz_id
    # @param [Array[String>] select_choice_ids
    def get(quiz_id:, select_choice_ids:)
      quiz = Quiz.select(:id, :commentary).find(quiz_id)

      answer_combinations = get_answer_combinations(quiz)
      Answer.new(quiz: quiz,
                 is_correct: correct?(answer_combinations, select_choice_ids),
                 combinations: answer_combinations)
    end

    private

    # 母音と選択肢の組み合わせを取得する
    #
    # @param [Quiz] quiz
    # @return [Array<AnswerCombination>]
    def get_answer_combinations(quiz)
      choices = quiz.choices.joins(:rhyme).select(SQL_COLUMS_GET)
      rhyme_contents = choices.map(&:rhyme_content).uniq
      answer_combinations = []

      rhyme_contents.each do |rhyme_content|
        choice_ids = choices
                     .select { |choice| choice.rhyme_content == rhyme_content }
                     .map { |item| item.choice_id.to_s }
        answer_combinations << AnswerCombination.new(rhyme: rhyme_content, choice_ids: choice_ids)
      end
      answer_combinations
    end

    # クイズの回答が正解か判定する
    #
    # @param [Array<AnswerCombination>] answer_combinations
    # @param [Array<String>] select_choice_ids ChoiceモデルのidのArray
    # @return [boolean] true:正解, false:不正解
    def correct?(answer_combinations, select_choice_ids)
      answer_combinations.each do |answer_combination|
        return true if answer_combination.correct?(select_choice_ids)
      end
      false
    end
  end
end
