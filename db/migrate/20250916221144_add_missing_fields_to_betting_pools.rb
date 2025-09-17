class AddMissingFieldsToBettingPools < ActiveRecord::Migration[8.0]
  def change
    add_column :betting_pools, :entry_fee, :decimal
    add_column :betting_pools, :pool_type, :string
    add_column :betting_pools, :active, :boolean
  end
end
