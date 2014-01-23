class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|
      t.string :username
      t.string :rol
      t.integer :entity_id
      t.string :entity_type
      t.timestamps
    end
    add_index :logins, :entity_id
  end
end
