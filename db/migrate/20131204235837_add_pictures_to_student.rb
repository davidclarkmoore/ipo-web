class AddPicturesToStudent < ActiveRecord::Migration
  def change
  	add_column :students, :profile_picture, :string
  	add_column :students, :cover_photo, :string
  end
end
