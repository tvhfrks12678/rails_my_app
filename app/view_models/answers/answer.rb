module ViewModels
  module Answers
    class Answer
      include ActiveModel::Model

      attr_reader :quiz_id, :commentary, :combinations, :is_correct

      validates :quiz_id, presence: true
      validates :commentary, presence: true
      validates :is_correct, inclusion: { in: [true, false] }
      validates :combinations, presence: true

      # MSG
      MSG_NOTHING_COMMENTARY = '　なし'.freeze

      # @param [Integer] quiz_id
      # @param [Array<Integer>] select_choice_ids
      def initialize(quiz_id:, select_choice_ids:)
        quiz = Quiz.select(:id, :commentary).find(quiz_id)
        answer_combinations = get_answer_combinations(quiz)
        is_correct = correct?(answer_combinations, select_choice_ids)

        @quiz_id = quiz_id
        @commentary = get_answer_commentary(quiz.commentary)
        @is_correct = is_correct
        @combinations = answer_combinations
      end

      private

      # 母音と選択肢の組み合わせを取得する
      #
      # @param [Quiz] quiz
      # @return [Array<AnswerCombination>]
      def get_answer_combinations(quiz)
        choices = quiz.choices.preload(:rhyme)

        answer_combinations = []

        choices.each do |choice|
          choice_rhyme = choice&.rhyme&.content
          choice_id = choice.id.to_s
          next if choice_rhyme.blank?

          answer_combinations = add_answer_combinations(choice_rhyme, choice_id, answer_combinations)
        end

        answer_combinations
      end

      # 母音と選択肢の組み合わせを追加する
      #
      # @param [String] choice_rhyme
      # @param [String] choice_id
      # @return [Array<AnswerCombination>]
      def add_answer_combinations(choice_rhyme, choice_id, answer_combinations)
        answer_combinations.each do |answer_combination|
          if answer_combination.rhyme == choice_rhyme
            answer_combination.choice_ids << choice_id
            return answer_combinations
          end
        end

        answer_combinations << ViewModels::Answers::AnswerCombination.new(rhyme: choice_rhyme,
                                                                          choice_ids: [choice_id])
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

      def get_answer_commentary(quiz_commentary)
        return quiz_commentary if quiz_commentary.present?

        MSG_NOTHING_COMMENTARY
      end
    end
  end
end
