# frozen_string_literal: true

module Forms
  module Quizzes
    class QuizForm
      include ActiveModel::Model

      attr_accessor :quiz, :commentary, :youtube_url, :youtube_start_time, :choices

      validates :commentary, length: { maximum: 255 }

      QUIZ_CHOICE_MIN = 3
      INITIAL_VALUE_OF_YOUTUBE_START_TIME = '00:00:00'
      YOUTUBE_START_TIME_FORMAT = '%X'

      delegate :persisted?, to: :quiz

      def initialize(attributes = nil, quiz: Quiz.new)
        @quiz = quiz

        if attributes.nil?
          attributes = default_attributes
          super(attributes)
          return
        end

        super(attributes)
        @choices = set_choice_for_update
      end

      def input_valid?
        quiz_valid = valid?
        choices_valid = check_choices_errors
        quiz_valid && choices_valid
      end

      def save(current_user)
        ActiveRecord::Base.transaction do
          Services::Quizzes::QuizFormSaveService.call(current_user, self)
          true
        rescue ActiveRecord::RecordInvalid
          false
        end
      end

      def select_list_of_rhyme_of_choice
        choices.map do |choice|
          rhyme = choice.rhyme
          next if rhyme.blank?

          [rhyme]
        end.compact
      end

      def to_model
        quiz
      end

      private

      def default_attributes
        {
          commentary: quiz.commentary,
          youtube_url: set_youtube_url,
          youtube_start_time: set_youtube_start_time,
          choices: set_init_choices
        }
      end

      def set_youtube_url
        return '' if quiz.youtube.blank?

        "#{Constants::Quizzes::Forms::YOUTUBE_URL_BEFORE_LIST[1]}#{quiz.youtube&.video_id}"
      end

      def set_youtube_start_time
        return INITIAL_VALUE_OF_YOUTUBE_START_TIME if quiz.youtube.blank?

        Time.at(quiz.youtube.start_time).utc.strftime(YOUTUBE_START_TIME_FORMAT)
      end

      def set_init_choices
        return set_choice_for_edit if quiz.choices.present?

        QUIZ_CHOICE_MIN.times.map do
          Forms::Quizzes::ChoiceForm.new(content: '', rhyme: '')
        end
      end

      def check_choices_errors
        choices.map(&:valid?).all? { |c| c }
      end

      def set_choice_for_edit
        quiz.choices.map do |choice|
          Forms::Quizzes::ChoiceForm.new(content: choice.content, rhyme: choice.rhyme&.content)
        end
      end

      def set_choice_for_update
        choices.map do |choice|
          Forms::Quizzes::ChoiceForm.new(content: choice[:content], rhyme: choice[:rhyme])
        end
      end
    end
  end
end
