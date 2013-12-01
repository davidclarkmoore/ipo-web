class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :description

      t.timestamps
    end
  end
end
