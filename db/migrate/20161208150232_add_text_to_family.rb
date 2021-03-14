class AddTextToFamily < ActiveRecord::Migration[4.2]
  def change
    add_column :families, :text, :boolean
  end
end
