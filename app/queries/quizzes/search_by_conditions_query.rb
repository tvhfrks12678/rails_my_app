# frozen_string_literal: true

module Queries
  module Quizzes
    class SearchByConditionsQuery < Query
      DATE_TO_DISPLAY_FORMAT = '%Y/%m/%d %H:%M:%S'

      def initialize(relation = Quiz.all)
        @relation = relation
      end

      def call(current_user:, search_word: '')
        relation = @relation.where(user: current_user)

        if search_word.present?
          ids = Choice.select(:quiz_id).where('content LIKE ?', "%#{search_word}%")
          relation = relation.where(id: ids).or(relation.where('commentary LIKE ?', "%#{search_word}%"))
        end

        relation.preload([choices: :rhyme], :youtube)
      end
    end
  end
end
