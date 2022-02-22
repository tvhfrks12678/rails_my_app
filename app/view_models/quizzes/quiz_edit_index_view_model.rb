# frozen_string_literal: true

module ViewModels
  module Quizzes
    class QuizEditIndexViewModel
      include ActiveModel::Model

      attr_reader :quiz_id, :question, :created_at

      validates :quiz_id, presence: true
      validates :question, presence: true
      validates :created_at, presence: true

      DELIMITER = ', '
      DATE_TO_DISPLAY_FORMAT = '%Y/%m/%d %H:%M:%S'

      # @param [Integer] quiz_id
      # @param [Array<Choice>] choices
      # @param [Time] created_at
      def initialize(quiz_id:, choices:, created_at:)
        @quiz_id = quiz_id
        @question = combine(choices)
        @created_at = created_at
      end

      private

      # @param [Array<Choice>] choices
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
        # @param [User] current_user
        def get_list(current_user)
          quizzes = Quiz.where(user: current_user).preload([choices: :rhyme], :youtube)
          quizzes.map do |quiz|
            created_at = quiz.created_at.strftime(DATE_TO_DISPLAY_FORMAT)
            new(quiz_id: quiz.id, choices: quiz.choices, created_at: created_at)
          end
        end
      end
    end
  end
end
