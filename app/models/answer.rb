class Answer
  include ActiveModel::Model

  attr_reader :quiz, :combinations, :msg_result, :is_correct

  validates :quiz, presence: true
  validates :is_correct, inclusion: { in: [true, false] }
  validates :combinations, presence: true
  validates :msg_result, presence: true

  # SQL
  SQL_COLUMS_GET = 'choices.id AS Choice_id, rhymes.content  AS rhyme_content'.freeze

  # MSG
  MSG_CORRECT_ANSWER = '○'.freeze
  MSG_INCORRECT_ANSWER = '×'.freeze

  # @param [Quiz] quiz
  # @param [Boolean] is_correct
  # @param [Array<AnswerCombination>] combinations
  # def initialize(quiz:, is_correct:, combinations:, msg_result:)
  def initialize(quiz:, combinations:, is_correct:, msg_result:)
    @quiz = quiz
    @is_correct = is_correct
    @combinations = combinations
    @msg_result = msg_result
  end

  class << self
    # 回答表示に関する情報を取得する

    # @param [String] quiz_id
    # @param [Array[String>] select_choice_ids
    def get(quiz_id:, select_choice_ids:)
      quiz = Quiz.select(:id, :commentary).find(quiz_id)

      answer_combinations = get_answer_combinations(quiz)
      is_correct = correct?(answer_combinations, select_choice_ids)

      Answer.new(quiz: quiz,
                 combinations: answer_combinations,
                 is_correct: is_correct,
                 msg_result: get_msg_answer_result(is_correct))
    end

    private

    # 母音と選択肢の組み合わせを取得する
    #
    # @param [Quiz] quiz
    # @return [Array<AnswerCombination>]
    def get_answer_combinations(quiz)
      choices = quiz.choices.joins(:rhyme).select(SQL_COLUMS_GET)
      rhyme_contents = choices.map(&:rhyme_content).uniq
      rhyme_contents.map do |rhyme_content|
        choice_ids = choices.select { |choice| choice.rhyme_content == rhyme_content }
                            .map { |item| item.choice_id.to_s }

        alphabet_rhyme_content = get_alphabet_rhyme(rhyme_content)
        AnswerCombination.new(rhyme: alphabet_rhyme_content, choice_ids: choice_ids)
      end
    end

    # 母音をローマ字にする
    #
    # @param [String] rhyme_content ひらがな、カタカナ、ローマ字混ざりの母音
    # @return [String] ローマ字のみの母音
    def get_alphabet_rhyme(rhyme_content)
      rhyme_content.gsub(/[あア]/, 'a').gsub(/[いイ]/, 'i').gsub(/[うウ]/, 'u').gsub(/[えエ]/, 'e').gsub(/[おオ]/, 'o')
    end

    # クイズの回答が正解か判定する
    #
    # @param [Array<AnswerCombination>] answer_combinations
    # @param [Array<String>] select_choice_ids ChoiceモデルのidのArray
    # @return [Boolean] true:正解, false:不正解
    def correct?(answer_combinations, select_choice_ids)
      return false if select_choice_ids.nil?

      answer_combinations.each do |answer_combination|
        return true if answer_combination.correct?(select_choice_ids)
      end
      false
    end

    # クイズの回答の結果のメッセージを取得する
    #
    # @param [Boolean] is_correct true:クイズの回答が正解, false:クイズの回答が不正解
    # @return [String] クイズの回答結果のメッセージ
    def get_msg_answer_result(is_correct)
      is_correct ? MSG_CORRECT_ANSWER : MSG_INCORRECT_ANSWER
    end
  end
end
