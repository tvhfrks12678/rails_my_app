module Forms
  module Quizzes
    class QuizForm
      include ActiveModel::Model

      attr_accessor :commentary, :choices

      validates :commentary, length: { maximum: 255 }

      QUIZ_CHOICE_MIN = 3

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
