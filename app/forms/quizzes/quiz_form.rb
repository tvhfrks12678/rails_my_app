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

      delegate :persisted?, to: :quiz

      def initialize(attributes = nil, quiz: Quiz.new)
        @quiz = quiz

        attributes ||= default_attributes
        super(attributes)
        @choices = set_choices
      end

      def input_valid?
        quiz_valid = valid?
        choices_valid = check_choices_errors
        quiz_valid && choices_valid
      end

      def save(current_user)
        ActiveRecord::Base.transaction do
          quiz_item = current_user.quizzes.create!(commentary: commentary)
          save_choices(quiz_item)
          save_youtube(quiz_item)
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
          choices: set_init_choices
        }
      end

      def check_choices_errors
        choices.map(&:valid?).all? { |c| c }
      end

      def save_choices(quiz_item)
        choices.map do |choice|
          next quiz_item.choices.create!(content: choice.content) if choice.rhyme.blank?

          rhyme = Rhyme.find_or_create_by!(content: choice.rhyme)
          quiz_item.choices.create!(content: choice.content, rhyme_id: rhyme.id)
        end
      end

      def save_youtube(quiz_item)
        return if youtube_url.blank?

        quiz_item.create_youtube!(video_id: youtube_id, start_time: youtube_start_time_seconds)
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
        QUIZ_CHOICE_MIN.times.map { { content: '', rhyme: '' } }
      end

      def set_choices
        choices.map do |choice|
          Forms::Quizzes::ChoiceForm.new(content: choice[:content], rhyme: choice[:rhyme])
        end
      end
    end
  end
end
