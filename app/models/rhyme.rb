class Rhyme < ApplicationRecord
  has_one :choice, dependent: :nullify
  validates :content, presence: true, uniqueness: true
end
