class AddProjectMedia < ActiveRecord::Migration
  def change
    create_table :project_media do |t|
      t.string :image
      t.integer :project_id
      t.foreign_key :projects
      t.integer :order

      t.timestamps
    end
  end
end
