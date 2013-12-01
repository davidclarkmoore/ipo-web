class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :username
      t.string :email
      t.string :rol
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token

      t.integer :entity_id
      t.string :entity_type
      t.timestamps
    end
    add_index :customers, :entity_id
  end
end
