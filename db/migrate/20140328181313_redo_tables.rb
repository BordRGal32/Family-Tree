class RedoTables < ActiveRecord::Migration
  def change
    drop_table :parent_ones
    drop_table :parent_twos
  end
end
