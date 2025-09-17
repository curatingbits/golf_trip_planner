class CreateBettingPools < ActiveRecord::Migration[8.0]
  def change
    create_table :betting_pools do |t|
      t.references :trip, null: false, foreign_key: true
      t.string :name
      t.decimal :cost_per_person
      t.text :description

      t.timestamps
    end
  end
end
