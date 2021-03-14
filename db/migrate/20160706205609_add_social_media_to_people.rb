class AddSocialMediaToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :social_media, :text
  end
end
