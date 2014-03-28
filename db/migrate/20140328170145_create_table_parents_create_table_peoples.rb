class CreateTableParentsCreateTablePeoples < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.column :parent_one_id, :int
      t.column :parent_two_id, :int
      t.timestamp
    end
    create_table :parent_ones do |t|
      t.column :person_id, :int
      t.timestamp
    end
    create_table :parent_twos do |t|
      t.column :person_id, :int
      t.timestamp
    end
    add_column :people, :parent_id, :int
    add_column :people, :gender, :string
    add_column :people, :birthday, :date
  end
end
