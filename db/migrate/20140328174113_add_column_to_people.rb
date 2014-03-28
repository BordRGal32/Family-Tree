class AddColumnToPeople < ActiveRecord::Migration
  def change
    add_column :people, :parent_relationship_id, :int
  end
end
