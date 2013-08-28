class IndexFieldHostsProperties < ActiveRecord::Migration
  def up
    execute "CREATE INDEX field_hosts_properties ON field_hosts USING GIN(properties)"
  end

  def down
    execute "DROP INDEX field_hosts_properties"
  end
end
