class AddActsAsParanoid < ActiveRecord::Migration
  def self.up
    add_column :locations, :deleted_at, :datetime
    add_index :locations, :deleted_at
  end

  def self.down
    remove_column :locations, :deleted_at
  end
end
