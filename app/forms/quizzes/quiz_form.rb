# frozen_string_literal: true

module Forms
  module Quizzes
    class QuizForm
      include ActiveModel::Model

      attr_accessor :commentary, :youtube_url, :youtube_start_time, :choices

      validates :commentary, length: { maximum: 255 }

      QUIZ_CHOICE_MIN = 3
      YOUTUBE_URL_BEFORE_LIST = ['https://youtu.be/', 'https://www.youtube.com/embed/'].freeze
      SECONDS_PER_MINUTES = 60
      MINUTES_PER_HOUR = 60

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
          quiz.update!(user: current_user, commentary: commentary)
          save_choices
          save_youtube
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

      attr_reader :quiz

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

        "#{YOUTUBE_URL_BEFORE_LIST[1]}#{quiz.youtube&.video_id}"
      end

      def set_youtube_start_time
        return INITIAL_VALUE_OF_YOUTUBE_START_TIME if quiz.youtube.blank?

        Time.at(quiz.youtube.start_time).utc.strftime(YOUTUBE_START_TIME_FORMAT)
      end

      def check_choices_errors
        choices.map(&:valid?).all? { |c| c }
      end

      def save_choices
        quiz.choices.delete_all
        choices.map do |choice|
          choice_content = choice.content
          choice_rhyme = choice.rhyme
          next quiz.choices.create!(content: choice_content) if choice_rhyme.blank?

          rhyme = Rhyme.find_or_create_by!(content: choice_rhyme)
          quiz.choices.create!(content: choice_content, rhyme_id: rhyme.id)
        end
      end

      def save_youtube
        quiz.youtube&.delete
        return if youtube_url.blank?

        quiz.create_youtube!(video_id: youtube_id, start_time: youtube_start_time_seconds)
      end

      def youtube_id
        YOUTUBE_URL_BEFORE_LIST.each do |youtube_url_before|
          youtube_id_match = youtube_url.match(/#{youtube_url_before}(.{11})/)
          next if youtube_id_match.nil?

          return youtube_id_match[1]
        end
      end

      def youtube_start_time_seconds
        times = youtube_start_time.split(':').map(&:to_i)
        hour = times[0]
        minutes = times[1]
        seconds = times[2]
        (hour * MINUTES_PER_HOUR * SECONDS_PER_MINUTES) + (minutes * SECONDS_PER_MINUTES) + seconds.to_i
      end

      def set_init_choices
        return set_choice_for_edit if quiz.choices.present?

        QUIZ_CHOICE_MIN.times.map do
          Forms::Quizzes::ChoiceForm.new(content: '', rhyme: '')
        end
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
