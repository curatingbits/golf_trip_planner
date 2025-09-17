class CreateBettingParticipations < ActiveRecord::Migration[8.0]
  def change
    create_table :betting_participations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :betting_pool, null: false, foreign_key: true
      t.datetime :joined_at

      t.timestamps
    end
  end
end
