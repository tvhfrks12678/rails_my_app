class Rhyme < ApplicationRecord
  VALID_CONTENT_REGEX = /\A[あいうえお]+\z/.freeze
  validates :content, presence: true, length: { maximum: 30 }, format: { with: VALID_CONTENT_REGEX }, uniqueness: true
end
