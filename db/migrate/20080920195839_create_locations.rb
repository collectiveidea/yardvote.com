class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :signs

      t.timestamps
    end
    
    add_index :locations, :signs
  end

  def self.down
    drop_table :locations
  end
end
