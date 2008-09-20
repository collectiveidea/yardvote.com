class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :reported_by

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
