class AddPronounsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :pronouns, :string
  end
end
