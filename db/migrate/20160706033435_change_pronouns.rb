class ChangePronouns < ActiveRecord::Migration[4.2]
  def change
    rename_column :pronouns, :pronouns, :preferred_pronouns
  end
end
