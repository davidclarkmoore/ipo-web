class RemoveEmailFromFieldhost < ActiveRecord::Migration
  def up
    remove_column :field_hosts, :email
  end

  def down
    add_column :field_hosts, :email, null: false
  end
end
