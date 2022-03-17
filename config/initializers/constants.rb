# frozen_string_literal: true

module Constants
  SITE_TITLE = '韻 DE クイズ'
  module Quizzes
    module Choices
      module Rhymes
        MAXIMUM_NUMBER_OF_CHARACTERS = 30
        MINIMUM_NUMBER_OF_CHARACTERS = 2
      end
    end

    module Forms
      YOUTUBE_URL_BEFORE_LIST = ['https://youtu.be/', 'https://www.youtube.com/embed/'].freeze
    end
  end

  module Forms
    module QuizEditIndex
      SELECT_BOX_ORDER_SORT = {
        DATE: { DESC: { VALUE: '1', OPTION: '投稿日が新しい' },
                ASC: { VALUE: '2', OPTION: '投稿日が古い' } },
        RHYNE_LENGTH: { DESC: { VALUE: '3', OPTION: '母音字数が多い' },
                        ASC: { VALUE: '4', OPTION: '母音字数が少ない' } }
      }.freeze
    end
  end
end
