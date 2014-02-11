class RemoveFieldsFromProjectSession < ActiveRecord::Migration
  def up
    remove_column :project_sessions, :start_date
    remove_column :project_sessions, :end_date
    remove_column :project_sessions, :title
    remove_column :project_sessions, :application_deadline
    add_column    :project_sessions, :session_id, :integer
  end

  def down
    add_column :project_sessions, :start_date, :date
    add_column :project_sessions, :end_date, :date
    add_column :project_sessions, :title, :string
    add_column :project_sessions, :application_deadline, :date
    remove_column :project_sessions, :session_id
  end
end
