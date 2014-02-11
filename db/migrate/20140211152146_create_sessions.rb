class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.string :duration
      t.date :application_deadline
      t.timestamps
    end
  end
end
