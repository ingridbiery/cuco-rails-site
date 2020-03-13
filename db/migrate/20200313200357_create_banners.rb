class CreateBanners < ActiveRecord::Migration[5.1]
  def change
    create_table :banners do |t|
      t.text :banner

      t.timestamps
    end
  end
end
