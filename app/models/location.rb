class Location < ActiveRecord::Base
  SIGN_OPTIONS = {
    'Blue'   => 'Obama & Democrats',
    'Red'    => 'McCain & Republicans',
    'Purple' => 'combination (ex. Obama + Republican Senator)'
  }
  
  acts_as_geocodable :address => {:street => :street, :locality => :city,
	  :region => :state, :postal_code => :zip}, :normalize_address => true
	
	acts_as_paranoid
	acts_as_audited
	  
  validates_inclusion_of :signs, :in => SIGN_OPTIONS, :message => "must be #{SIGN_OPTIONS.keys.to_sentence(:connector => 'or')}"
  
  named_scope :recent, :order => 'created_at DESC, updated_at DESC'
  named_scope :with_geocodes, :include => {:geocoding => :geocode}
  
  named_scope :in_box, lambda{|northeast, southwest|
    southwest_latitude, southwest_longitude = southwest.split(',')
    northeast_latitude, northeast_longitude = northeast.split(',')
    {:conditions => {:geocodes => {
      :longitude => (southwest_longitude..northeast_longitude), 
      :latitude => (southwest_latitude..northeast_latitude)}}}
  }
  
  named_scope :sign_counts, :select => 'locations.signs, COUNT(locations.signs) AS count', :group => 'locations.signs', :order => 'count DESC'
  
  def to_json(options={})
    super options.merge(:except => :deleted_at, :include => {:geocoding => {:only => [], 
      :include => {:geocode => {:only => [:latitude, :longitude]}}}})
  end
  
  # inefficient method for cities
  def city_info
    locations = Location.all(:select => 'signs', :conditions => {:city => self.city, :state => self.state})
    info = locations.group_by(&:signs).max{|a,b| a[1].size <=> b[1].size}[1][0]
    {:signs => info.signs, :count => locations.size}
  end
end
