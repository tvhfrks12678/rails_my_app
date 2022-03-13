# frozen_string_literal: true

module Queries
  module Quizzes
    class SearchForEditIndexQuery < Query
      SQL_WHERE_SEARCH_WORD_LIKE = 'commentary LIKE ? or choices.content LIKE ? or rhymes.content like ?'

      SQL_WHERE_RHYME_CHARACTORS_BETWEEN = 'CHAR_LENGTH(rhymes.content) BETWEEN ? AND ?'

      def initialize(relation = Quiz.all)
        @relation = relation
      end

      def call(current_user:, quiz_posts_search_form:)
        relation = @relation.where(user: current_user)
        relation = search_word_by(relation, quiz_posts_search_form.search_word)

        relation = search_date_by(relation, quiz_posts_search_form.from_date, quiz_posts_search_form.to_date)

        relation = search_number_of_rhyme(relation,
                                          quiz_posts_search_form.from_rhyme_characters, quiz_posts_search_form.to_rhyme_characters)

        relation.preload([choices: :rhyme], :youtube)
      end

      private

      def search_word_by(relation, word)
        return relation if word.blank?

        partial_match_word = "%#{word}%"

        ids = relation.left_joins(choices: :rhyme).where(SQL_WHERE_SEARCH_WORD_LIKE, partial_match_word,
                                                         partial_match_word, partial_match_word).pluck(:id).uniq
        relation.where(id: ids)
      end

      def search_number_of_rhyme(relation, from_rhyme_characters, to_rhyme_characters)
        from_rhyme_characters_blank = from_rhyme_characters.blank?
        to_rhyme_characters_blank = to_rhyme_characters.blank?

        return relation if from_rhyme_characters_blank && to_rhyme_characters_blank

        constants_rhyme = Constants::Quizzes::Choices::Rhymes

        from_rhyme_characters = constants_rhyme::MINIMUM_NUMBER_OF_CHARACTERS if from_rhyme_characters_blank
        to_rhyme_characters = constants_rhyme::MAXIMUM_NUMBER_OF_CHARACTERS if to_rhyme_characters_blank

        ids = relation.left_joins(choices: :rhyme).where(SQL_WHERE_RHYME_CHARACTORS_BETWEEN, from_rhyme_characters,
                                                         to_rhyme_characters).pluck(:id).uniq

        relation.where(id: ids)
      end

      def search_date_by(relation, from_date, to_date)
        from_date_blank = from_date.blank?
        to_date_blank = to_date.blank?

        return relation if from_date_blank && to_date_blank

        return relation.where(created_at: from_date..) if to_date_blank

        to_date_end_of_day = Time.zone.parse(to_date).end_of_day

        return relation.where(created_at: ..to_date_end_of_day) if from_date_blank

        relation.where(created_at: from_date..to_date_end_of_day)
      end
    end
  end
end
