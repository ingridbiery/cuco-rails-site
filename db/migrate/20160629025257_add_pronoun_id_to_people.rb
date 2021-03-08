class AddPronounIdToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :pronoun_id, :integer
  end
end
