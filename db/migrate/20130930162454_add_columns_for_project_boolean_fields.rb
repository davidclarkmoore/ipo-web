class AddColumnsForProjectBooleanFields < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.boolean :team_mode
      t.boolean :location_private
    end
  end
end
