class AddSocialMediaToPeople < ActiveRecord::Migration
  def change
    add_column :people, :social_media, :text
  end
end
