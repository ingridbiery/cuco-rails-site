class AddPhoneToFamily < ActiveRecord::Migration
  def change
    add_column :families, :phone, :string
  end
end
