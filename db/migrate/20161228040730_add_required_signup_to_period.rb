class AddRequiredSignupToPeriod < ActiveRecord::Migration
  def change
    add_column :periods, :required_signup, :boolean
  end
end
