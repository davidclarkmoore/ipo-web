class AddProjectHstoreAndFields < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.remove :start_date
      t.remove :end_date
      t.hstore :properties
      t.string :status
      t.string :wizard_status
    end
  end
end
