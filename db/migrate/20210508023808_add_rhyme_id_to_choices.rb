class AddRhymeIdToChoices < ActiveRecord::Migration[6.1]
  def change
    add_reference :choices, :rhyme, foreign_key: true
  end
end
