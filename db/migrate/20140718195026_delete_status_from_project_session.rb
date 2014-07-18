class DeleteStatusFromProjectSession < ActiveRecord::Migration
  def change
  	remove_column :project_sessions, :status
  end
end
