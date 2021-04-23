class CreateQuizzes < ActiveRecord::Migration[6.1]
  def change
    create_table :quizzes do |t|
      t.text :commentary
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :quizzes, %i[user_id created_at]
  end
end
