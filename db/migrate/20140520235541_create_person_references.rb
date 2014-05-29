class CreatePersonReferences < ActiveRecord::Migration
  def change
    create_table :person_references do |t|
      t.string :reference_type #spiritual, academic, other
      t.belongs_to :reference
      t.references :referencer, polymorphic: true
      t.timestamps
    end
  end
end
