class CreatePronouns < ActiveRecord::Migration[4.2]
  def change
    create_table :pronouns do |t|
      t.string :pronouns
    end
    add_index :pronouns, :pronouns, unique: true
  end
end
