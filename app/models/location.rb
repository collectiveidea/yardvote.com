class Location < ActiveRecord::Base
  SIGN_OPTIONS = {
    'Blue'   => 'Democrats',
    'Red'    => 'Republicans',
    'Purple' => 'Both'
  }
  
  acts_as_geocodable :address => {:street => :street, :locality => :city,
	  :region => :state, :postal_code => :zip}, :normalize_address => true
	
	acts_as_paranoid
	acts_as_audited

  validates_inclusion_of :signs, :in => SIGN_OPTIONS, :message => "must be #{SIGN_OPTIONS.keys.to_sentence(:connector => 'or')}"
  validate :check_geocode_precision
  
  named_scope :recent, :order => 'created_at DESC, updated_at DESC'
  named_scope :with_geocodes, :include => {:geocoding => :geocode}
  
  named_scope :in_box, lambda{|northeast, southwest|
    if northeast && southwest
      southwest_latitude, southwest_longitude = southwest.split(',')
      northeast_latitude, northeast_longitude = northeast.split(',')
      {:conditions => {:geocodes => {
        :longitude => (southwest_longitude..northeast_longitude), 
        :latitude => (southwest_latitude..northeast_latitude)}}}
    else
      {}
    end
  }
  
  named_scope :sign_counts, :select => 'locations.signs, COUNT(locations.signs) AS count', :group => 'locations.signs', :order => 'count DESC'
  
  def to_json(options={})
    super options.merge(:except => :deleted_at, :include => {:geocoding => {:only => [], 
      :include => {:geocode => {:only => [:latitude, :longitude]}}}})
  end
  
  def self.city_count 
    count(:select => 'DISTINCT(city)')
  end
  
  def self.state_count 
    count(:select => 'DISTINCT(state)')
  end

private
  def self.existing_address(location)
    location.send :attach_geocode
    # find others with the same address
    Location.first(:conditions => {:street => location.street, :city => location.city, :state => location.state, :zip => location.zip})
  end
  
  def check_geocode_precision
    attach_geocode
    errors.add_to_base "We can't find a precise enough address match." if geocode.blank? || geocode.precision != 'address'
  end
end
