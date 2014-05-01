class FixAddressInProject < ActiveRecord::Migration
  def up
    change_table :projects do |t|
      t.rename :address, :location_street_address
      t.string :location_city
      t.string :location_state_or_province
      t.string :location_country
    end
  end

  def down 
    change_table :projects do |t|
      t.rename :location_street_address, :address
      t.remove :location_city
      t.remove :location_state_or_province
      t.remove :location_country
    end
  end
end
