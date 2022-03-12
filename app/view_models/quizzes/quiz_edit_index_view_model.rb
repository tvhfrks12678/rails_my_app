# frozen_string_literal: true

module ViewModels
  module Quizzes
    class QuizEditIndexViewModel
      include ActiveModel::Model

      attr_reader :quiz_id, :choices, :commentary, :rhymes, :created_at

      validates :quiz_id, presence: true
      validates :choices, presence: true
      validates :commentary, presence: true
      validates :created_at, presence: true

      DELIMITER = ', '
      DATE_TO_DISPLAY_FORMAT = '%Y/%m/%d %H:%M:%S'

      # @param [Quiz] quiz
      def initialize(quiz:)
        @quiz_id = quiz.id
        @choices = combine(quiz.choices)
        @commentary = quiz.commentary
        @rhymes = combine_rhymes(quiz.choices)
        @created_at = quiz.created_at.strftime(DATE_TO_DISPLAY_FORMAT)
      end

      private

      # @param [Array<Choice>] quiz_choices
      # @return [String] choices
      def combine(quiz_choices)
        choices = ''.dup
        choices_last_array_number = quiz_choices.length - 1
        quiz_choices.each_with_index do |choice, index|
          choices << choice.content
          next if choices_last_array_number == index

          choices << DELIMITER
        end
        choices
      end

      def combine_display(quiz_choices)
        choices = ''.dup
        choices_last_array_number = quiz_choices.length - 1
        quiz_choices.each_with_index do |choice, index|
          choices << choice
          next if choices_last_array_number == index

          choices << DELIMITER
        end
        choices
      end

      def combine_rhymes(choices)
        rhymes = []
        choices.each do |choice|
          next if choice.rhyme.blank?

          rhyme = choice.rhyme.content
          next if rhymes.include?(rhyme)

          rhymes << rhyme
        end

        rhymes.join(DELIMITER)
      end
    end
  end
end
