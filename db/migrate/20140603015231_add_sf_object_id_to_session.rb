class AddSfObjectIdToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :sf_object_id, :string
  end
end
