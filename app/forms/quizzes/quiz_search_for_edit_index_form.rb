# frozen_string_literal: true

module Forms
  module Quizzes
    class QuizSearchForEditIndexForm
      include ActiveModel::Model

      attr_accessor :search_word, :from_rhyme_characters, :to_rhyme_characters, :from_date, :to_date,
                    :rhyme_select_box_choices, :select_box_init_msg, :existing_youtube, :no_youtube,
                    :sort_order, :sort_order_select_box_choices

      MESSAGE_SELECT_BOX_INIT = ' '

      def initialize(attributes = nil)
        attributes ||= default_attributes
        super(attributes)

        set_select_box
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

      def set_select_box
        @select_box_init_msg = MESSAGE_SELECT_BOX_INIT
        set_order_sort_select_box
        set_rhyme_select_box
      end

      def set_rhyme_select_box
        constants_rhyme = Constants::Quizzes::Choices::Rhymes
        @rhyme_select_box_choices =
          constants_rhyme::MINIMUM_NUMBER_OF_CHARACTERS..constants_rhyme::MAXIMUM_NUMBER_OF_CHARACTERS
      end

      def set_order_sort_select_box
        @sort_order_select_box_choices = {}
        select_box_order_sort = Constants::Forms::QuizEditIndex::SELECT_BOX_ORDER_SORT

        select_box_order_sort.each do |_key, content|
          content.each do |_order_sort_key, select_box_choices|
            @sort_order_select_box_choices[(select_box_choices[:OPTION]).to_sym] = select_box_choices[:VALUE]
          end
        end
      end
    end
  end
end
