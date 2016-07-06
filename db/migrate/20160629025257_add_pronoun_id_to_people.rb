class AddPronounIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :pronoun_id, :integer
  end
end
