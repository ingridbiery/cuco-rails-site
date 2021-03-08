class AddPhoneToFamily < ActiveRecord::Migration[4.2]
  def change
    add_column :families, :phone, :string
  end
end
