# frozen_string_literal: true

module Services
  module Quizzes
    class QuizFormSaveService
      include ServiceModule
      private_class_method :new

      SECONDS_PER_MINUTES = 60
      MINUTES_PER_HOUR = 60

      private

      def initialize(user, quiz_form)
        @user = user
        @quiz_form = quiz_form
      end

      def call
        save_quiz
      end

      def save_quiz
        quiz = @quiz_form.quiz
        quiz.update!(user: @user, commentary: @quiz_form.commentary)
        save_choices
        save_youtube
      end

      def save_choices
        quiz = @quiz_form.quiz
        quiz.choices.delete_all
        @quiz_form.choices.map do |choice|
          choice_content = choice.content
          choice_rhyme = choice.rhyme
          next quiz.choices.create!(content: choice_content) if choice_rhyme.blank?

          rhyme = Rhyme.find_or_create_by!(content: choice_rhyme)
          quiz.choices.create!(content: choice_content, rhyme_id: rhyme.id)
        end
      end

      def save_youtube
        quiz = @quiz_form.quiz
        youtube_url = @quiz_form.youtube_url
        quiz.youtube&.delete
        return if youtube_url.blank?

        quiz.create_youtube!(video_id: get_youtube_id_by(youtube_url),
                             start_time: get_youtube_start_time_seconds(@quiz_form.youtube_start_time))
      end

      def get_youtube_id_by(youtube_url)
        Constants::Quizzes::Forms::YOUTUBE_URL_BEFORE_LIST.each do |youtube_url_before|
          youtube_id_match = youtube_url.match(/#{youtube_url_before}(.{11})/)
          next if youtube_id_match.nil?

          return youtube_id_match[1]
        end
      end

      def get_youtube_start_time_seconds(youtube_start_time)
        times = youtube_start_time.split(':').map(&:to_i)
        hour = times[0]
        minutes = times[1]
        seconds = times[2]
        (hour * MINUTES_PER_HOUR * SECONDS_PER_MINUTES) + (minutes * SECONDS_PER_MINUTES) + seconds.to_i
      end
    end
  end
end
