class CreateYoutubes < ActiveRecord::Migration[6.1]
  def change
    create_table :youtubes do |t|
      t.string :video_id
      t.integer :start_time
      t.references :quiz, null: false, foreign_key: true

      t.timestamps
    end
    add_index :youtubes, %i[video_id start_time], unique: true
  end
end
