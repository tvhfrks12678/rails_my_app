class Rhyme < ApplicationRecord
  has_one :choice, dependent: :nullify
  VALID_CONTENT_REGEX = /\A[あいうえおaiueo]+\z/.freeze
  validates :content, presence: true, length: { maximum: 30 },
                      format: { with: VALID_CONTENT_REGEX, message: :invalid_rhyme }, uniqueness: true

  SELECT_BOX_DEFAULT_NAME = '韻なし'.freeze
  SELECT_BOX_DEFAULT_ID = ''.freeze

  class << self
    # 母音とIdの組み合わせを取得する
    #
    # @param [Array<Rhyme>] rhymes RhymeモデルのArray
    # @return [Hash] 母音とIdの組み合わせのHash
    def get_rhyme_ids_by_rhyme_content(rhymes)
      rhyme_ids_by_rhyme_content = {}
      rhymes.each do |rhyme|
        next if rhyme.content.nil?

        rhyme_ids_by_rhyme_content[rhyme.content.to_sym] = rhyme.id
      end
      rhyme_ids_by_rhyme_content
    end

    # クイズ投稿画面の選択肢の母音のSelectBoxの値を取得する
    #
    # @param [Array<Rhyme>] rhymes RhymeモデルのArray
    # @return [Array<Hash>] クイズ投稿画面の選択肢の母音のSelectBoxの値のArray
    def get_select_box_choice_rhyme(rhymes)
      select_box_choice_rhyme = [{ id: SELECT_BOX_DEFAULT_ID, name: SELECT_BOX_DEFAULT_NAME }]
      rhymes.each do |rhyme|
        next if rhyme.content.nil?

        select_box_choice_rhyme << { id: rhyme.content, name: rhyme.content }
      end
      select_box_choice_rhyme
    end
  end
end
