# frozen_string_literal: true

module Queries
  module Quizzes
    class SearchForEditIndexQuery < Query
      SQL_WHERE_SEARCH_WORD_LIKE = 'commentary LIKE ? or choices.content LIKE ? or rhymes.content like ?'

      SQL_WHERE_RHYME_CHARACTORS_BETWEEN = 'CHAR_LENGTH(rhymes.content) BETWEEN ? AND ?'

      SORT_ORDER = { SQL_MAX_RHYME_LENGTH: 'MAX(CHAR_LENGTH(rhymes.content)) AS',
                     MAX_RHYME_LENGTH_COLUMN: 'max_rhyme_length' }.freeze

      def initialize(relation = Quiz.all)
        @relation = relation
      end

      def call(current_user:, quiz_posts_search_form:)
        relation = @relation.where(user: current_user)

        relation = search_by_word(relation, quiz_posts_search_form.search_word)

        relation = search_by_number_of_rhyme(relation, quiz_posts_search_form.from_rhyme_characters,
                                             quiz_posts_search_form.to_rhyme_characters)

        relation = search_by_date(relation, quiz_posts_search_form.from_date,
                                  quiz_posts_search_form.to_date)

        relation = search_by_youtube(relation,
                                     quiz_posts_search_form.existing_youtube, quiz_posts_search_form.no_youtube)

        relation = sort(relation, quiz_posts_search_form.sort_order)
        relation.preload([choices: :rhyme], :youtube)
      end

      private

      def search_by_word(relation, search_word)
        return relation if search_word.nil?

        words = search_word.split(/[[:blank:]]+/)

        words.each do |word|
          partial_match_word = "%#{word}%"

          ids = relation.left_outer_joins(choices: :rhyme).where(SQL_WHERE_SEARCH_WORD_LIKE, partial_match_word,
                                                                 partial_match_word, partial_match_word).pluck(:id).uniq
          relation = relation.where(id: ids)
        end

        relation
      end

      def search_by_date(relation, from_date, to_date)
        from_date_blank = from_date.blank?
        to_date_blank = to_date.blank?

        return relation if from_date_blank && to_date_blank

        return relation.where(created_at: from_date..) if to_date_blank

        to_date_end_of_day = Time.zone.parse(to_date).end_of_day

        return relation.where(created_at: ..to_date_end_of_day) if from_date_blank

        relation.where(created_at: from_date..to_date_end_of_day)
      end

      def search_by_number_of_rhyme(relation, from_rhyme_characters, to_rhyme_characters)
        from_rhyme_characters_blank = from_rhyme_characters.blank?
        to_rhyme_characters_blank = to_rhyme_characters.blank?

        return relation if from_rhyme_characters_blank && to_rhyme_characters_blank

        constants_rhyme = Constants::Quizzes::Choices::Rhymes

        from_rhyme_characters = constants_rhyme::MINIMUM_NUMBER_OF_CHARACTERS if from_rhyme_characters_blank
        to_rhyme_characters = constants_rhyme::MAXIMUM_NUMBER_OF_CHARACTERS if to_rhyme_characters_blank

        ids = relation.joins(choices: :rhyme).select(:id).where(SQL_WHERE_RHYME_CHARACTORS_BETWEEN, from_rhyme_characters,
                                                                to_rhyme_characters)
        relation.where(id: ids)
      end

      def search_by_youtube(relation, existing_youtube, no_youtube)
        return relation if existing_youtube == no_youtube
        return relation.joins(:youtube) if existing_youtube

        relation.left_outer_joins(:youtube).where(youtube: { id: nil })
      end

      def sort(relation, sort_order)
        select_box_order_sort = Constants::Forms::QuizEditIndex::SELECT_BOX_ORDER_SORT

        if sort_order == select_box_order_sort[:DATE][:ASC][:VALUE]
          return relation.unscope(:order).order(created_at: 'ASC')
        end

        return sort_rhymes_length(relation, 'DESC') if sort_order == select_box_order_sort[:RHYNE_LENGTH][:DESC][:VALUE]

        return sort_rhymes_length(relation, 'ASC') if sort_order == select_box_order_sort[:RHYNE_LENGTH][:ASC][:VALUE]

        relation
      end

      def sort_rhymes_length(relation, order)
        max_rhyme_length_col = SORT_ORDER[:MAX_RHYME_LENGTH_COLUMN]
        relation.joins(choices: :rhyme).group(:id)
                .select(:id, :commentary, :created_at,
                        "#{SORT_ORDER[:SQL_MAX_RHYME_LENGTH]} #{max_rhyme_length_col}")
                .unscope(:order).order("#{max_rhyme_length_col} #{order}")
      end
    end
  end
end
