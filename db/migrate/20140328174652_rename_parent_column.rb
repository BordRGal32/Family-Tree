class RenameParentColumn < ActiveRecord::Migration
  def change
    remove_column :people, :parent_relationship_id
  end
end
