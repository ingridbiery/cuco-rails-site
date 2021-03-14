class AddRequiredSignupToPeriod < ActiveRecord::Migration[4.2]
  def change
    add_column :periods, :required_signup, :boolean
  end
end
