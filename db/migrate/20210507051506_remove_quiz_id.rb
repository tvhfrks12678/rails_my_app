class RemoveQuizId < ActiveRecord::Migration[6.1]
  def change
    remove_reference :rhymes, :quiz, foreign_key: true
  end
end
