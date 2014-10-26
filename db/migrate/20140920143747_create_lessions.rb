class CreateLessions < ActiveRecord::Migration
  def change
    create_table :lessions do |t|
      t.string :title
      t.text :description
      t.text :video

      t.timestamps
    end
  end
end
