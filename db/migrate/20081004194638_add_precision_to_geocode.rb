class AddPrecisionToGeocode < ActiveRecord::Migration
  def self.up
    add_column "geocodes", "precision", :string
    
    add_index "geocodes", ["locality"], :name => "geocodes_locality_index"
    add_index "geocodes", ["region"], :name => "geocodes_region_index"
    add_index "geocodes", ["postal_code"], :name => "geocodes_postal_code_index"
    add_index "geocodes", ["country"], :name => "geocodes_country_index"
    add_index "geocodes", ["precision"], :name => "geocodes_precision_index"
  end

  def self.down
    remove_index "geocodes", :name => "geocodes_region_index"
    remove_index "geocodes", :name => "geocodes_postal_code_index"
    remove_index "geocodes", :name => "geocodes_country_index"
    remove_index "geocodes", :name => "geocodes_precision_index"

    remove_column "geocodes", "precision"
  end
end
