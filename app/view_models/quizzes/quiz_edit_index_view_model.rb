# frozen_string_literal: true

module ViewModels
  module Quizzes
    class QuizEditIndexViewModel
      include ActiveModel::Model

      attr_reader :quiz_id, :question, :commentary, :created_at

      validates :quiz_id, presence: true
      validates :question, presence: true
      validates :commentary, presence: true
      validates :created_at, presence: true

      DELIMITER = ', '
      DATE_TO_DISPLAY_FORMAT = '%Y/%m/%d %H:%M:%S'

      # @param [Quiz] quiz
      def initialize(quiz:)
        @quiz_id = quiz.id
        @question = combine(quiz.choices)
        @commentary = quiz.commentary
        @created_at = quiz.created_at.strftime(DATE_TO_DISPLAY_FORMAT)
      end

      private

      # @param [Array<Choice>] choices
      # @return [String] question
      def combine(choices)
        question = ''.dup
        choices_last_array_number = choices.length - 1
        choices.each_with_index do |choice, index|
          question << choice.content
          next if choices_last_array_number == index

          question << DELIMITER
        end
        question
      end

      class << self
        # 投稿したクイズを検索する

        # @param [User] current_user
        # @param [String] search_word
        # @return [Array<QuizEditIndexViewModel>]
        def get_search_list_by(current_user:, search_word:)
          quizzes = Quiz.search_by(current_user: current_user, search_word: search_word)
          quizzes.map do |quiz|
            new(quiz: quiz)
          end
        end
      end
    end
  end
end
