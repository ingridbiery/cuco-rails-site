class ChangePronouns < ActiveRecord::Migration
  def change
    rename_column :pronouns, :pronouns, :preferred_pronouns
  end
end
