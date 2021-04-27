class RenameTableFromQuizChoicesToChoices < ActiveRecord::Migration[6.1]
  def change
    rename_table :quiz_choices, :choices
  end
end
