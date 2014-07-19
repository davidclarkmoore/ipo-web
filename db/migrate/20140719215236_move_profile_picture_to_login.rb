class MoveProfilePictureToLogin < ActiveRecord::Migration
  def change
  	remove_column :field_hosts, :profile_picture
  	remove_column :students, :profile_picture
  	add_column :logins, :profile_picture, :string
  end
end
