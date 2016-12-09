class AddTextToFamily < ActiveRecord::Migration
  def change
    add_column :families, :text, :boolean
  end
end
