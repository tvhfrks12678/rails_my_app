module ViewModels
  module Answers
    class AnswerCombination
      include ActiveModel::Model

      attr_reader :rhyme, :choice_ids

      validates :rhyme, presence: true
      validates :choice_ids, presence: true

      # @param [String] rhyme
      # @param [Array<String>] choice_ids
      def initialize(rhyme:, choice_ids:)
        @rhyme = rhyme
        @choice_ids = choice_ids
      end

      # 選ばれた選択肢が正しいか判定する
      # @param [Array<String>] select_choice_ids
      # @return [Boolean] true: 組み合わせが正しい, false: 組み合わせが正しくない
      def correct?(select_choice_ids)
        @choice_ids.sort == select_choice_ids.sort
      end
    end
  end
end
