class ChangeCourseFeeToDecimal < ActiveRecord::Migration
  def change
    remove_column :courses, :fee
    add_column :courses, :fee, :decimal, :precision => 5, :scale => 2
  end
end
