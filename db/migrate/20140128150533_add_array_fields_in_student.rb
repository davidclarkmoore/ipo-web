class AddArrayFieldsInStudent < ActiveRecord::Migration
  def change
    add_column :students, :fields_of_study, :string, array: true
    add_column :students, :passions, :string, array: true
    add_column :students, :experiences, :string, array: true
    add_column :students, :spoken_languages, :string, array: true
    add_column :students, :heard_about_ipo, :string, array: true
  end
end
