module Forms
  module Quizzes
    class ChoiceForm
      include ActiveModel::Model

      attr_accessor :content, :rhyme

      validates :content, length: { maximum: 30 }, presence: true
      VALID_CONTENT_REGEX = /\A[あいうえおaiueo]+\z/.freeze
      validates :rhyme, length: { maximum: 30 }, allow_blank: true,
                        format: { with: VALID_CONTENT_REGEX, message: :invalid_rhyme }

      def initialize(content: '', rhyme: '')
        @content = content
        @rhyme = rhyme
      end
    end
  end
end
