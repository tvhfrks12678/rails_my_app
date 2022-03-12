# frozen_string_literal: true

module Forms
  module Quizzes
    class QuizSearchForEditIndexForm
      include ActiveModel::Model

      attr_accessor :search_word, :from_rhyme_characters, :to_rhyme_characters, :from_date, :to_date,
                    :rhyme_select_box_choices, :rhyme_select_box_init_msg

      MESSAGE_SELECT_BOX_INIT = '選択してください'

      def initialize(attributes = nil)
        attributes ||= default_attributes
        super(attributes)

        set_rhyme_select_box
      end

      def search(current_user)
        quizzes = Quiz.search_by(current_user: current_user, quiz_posts_search_form: self)
        quizzes.map do |quiz|
          ViewModels::Quizzes::QuizEditIndexViewModel.new(quiz: quiz)
        end
      end

      private

      def default_attributes
        {
          search_word: '',
          from_rhyme_characters: '',
          to_rhyme_characters: '',
          from_date: '',
          to_date: ''
        }
      end

      def set_rhyme_select_box
        @rhyme_select_box_init_msg = MESSAGE_SELECT_BOX_INIT

        constants_rhyme = Constants::Quizzes::Choices::Rhymes
        @rhyme_select_box_choices =
          constants_rhyme::MINIMUM_NUMBER_OF_CHARACTERS..constants_rhyme::MAXIMUM_NUMBER_OF_CHARACTERS
      end
    end
  end
end
