class CreateQuizChoices < ActiveRecord::Migration[6.1]
  def change
    create_table :quiz_choices do |t|
      t.text :content
      t.references :quiz, null: false, foreign_key: true

      t.timestamps
    end
  end
end
