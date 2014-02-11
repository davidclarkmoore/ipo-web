class AddFieldsToStudent < ActiveRecord::Migration
  def change
    add_column :students, :profile_picture, :string
    add_column :students, :cover_photo, :string
    add_column :students, :biography, :text
    add_column :students, :public_contact_information, :text
    add_column :students, :published_status, :boolean, default: false
  end
end
