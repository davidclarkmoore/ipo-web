class DeleteApplicationDeadlineFromProjectSession < ActiveRecord::Migration
  def change
  	remove_column :project_sessions, :application_deadline
  end
end
