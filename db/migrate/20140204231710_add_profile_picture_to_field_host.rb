class AddProfilePictureToFieldHost < ActiveRecord::Migration
  def change
    add_column :field_hosts, :profile_picture, :string
  end
end
