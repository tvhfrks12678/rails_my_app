# frozen_string_literal: true

module ViewModels
  module Quizzes
    class QuizEditIndexViewModel
      include ActiveModel::Model

      attr_reader :quiz_id, :choices, :commentary, :rhymes, :with_or_without_youtube, :created_at

      validates :quiz_id, presence: true
      validates :choices, presence: true
      validates :commentary, presence: true
      validates :created_at, presence: true

      DELIMITER = ', '
      DATE_TO_DISPLAY_FORMAT = '%Y/%m/%d %H:%M:%S'

      MAXIMUM_DISPLAY_NUMBER_CHOICES = 60
      MAXIMUM_DISPLAY_NUMBER_COMMENTARY = 40

      SYMBOL_FOR_TEXT_ABBREVIATION = '...'

      SYMBOL_FOR_YOUTUBE = '○'
      SYMBOL_FOR_NO_YOUTUBE = '×'

      # @param [Quiz] quiz
      def initialize(quiz:)
        @quiz_id = quiz.id
        @choices = get_choices_for_display(quiz.choices)
        @rhymes = combine_rhymes(quiz.choices)
        @commentary = omit_text(quiz.commentary, MAXIMUM_DISPLAY_NUMBER_COMMENTARY)
        @with_or_without_youtube = get_with_or_without_youtube(quiz)
        @created_at = quiz.created_at.strftime(DATE_TO_DISPLAY_FORMAT)
      end

      private

      def get_choices_for_display(quiz_choices)
        choices = combine_choices(quiz_choices)
        omit_text(choices, MAXIMUM_DISPLAY_NUMBER_CHOICES)
      end

      # @param [Array<Choice>] quiz_choices
      # @return [String] choices
      def combine_choices(quiz_choices)
        choices_text = ''.dup
        choices_last_array_number = quiz_choices.length - 1
        quiz_choices.each_with_index do |choice, index|
          choices_text << choice.content
          next if choices_last_array_number == index

          choices_text << DELIMITER
        end
        choices_text
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

      def omit_text(text, maximum_display_number)
        return text if text.length < maximum_display_number

        omitted_text = text.match(/[\s\S]{#{maximum_display_number}}/)
        "#{omitted_text}#{SYMBOL_FOR_TEXT_ABBREVIATION}"
      end

      def get_with_or_without_youtube(quiz)
        return SYMBOL_FOR_NO_YOUTUBE if quiz.youtube.nil?

        SYMBOL_FOR_YOUTUBE
      end
    end
  end
end
