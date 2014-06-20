class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.references :student 
      t.string :transcation_id
      t.string :customer_id
      t.boolean :recurring
      t.string :subscription_id
      t.string :status
      t.decimal :amount, :precision => 10, :scale => 2
      t.timestamps
    end
  end
end
