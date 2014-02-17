class RemoveFieldsFromProjectSession < ActiveRecord::Migration
  def up
    remove_column :project_sessions, :start_date
    remove_column :project_sessions, :end_date
    remove_column :project_sessions, :title
    add_column    :project_sessions, :session_id, :integer
  end

  def down
    add_column :project_sessions, :start_date, :date
    add_column :project_sessions, :end_date, :date
    add_column :project_sessions, :title, :string
    remove_column :project_sessions, :session_id
  end
end
