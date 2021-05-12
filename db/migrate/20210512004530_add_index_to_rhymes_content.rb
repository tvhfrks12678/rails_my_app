class AddIndexToRhymesContent < ActiveRecord::Migration[6.1]
  def change
    add_index :rhymes, :content, unique: true
  end
end
