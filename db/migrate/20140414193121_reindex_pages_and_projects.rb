class ReindexPagesAndProjects < ActiveRecord::Migration
  def up
    Project.reindex
    Refinery::Page.reindex
  end

  def down
  end
end
