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
  
  named_scope :sign_counts, :select => 'locations.signs, COUNT(locations.signs) AS count', :group => 'locations.signs', :order => 'count DESC'
  
  def to_json(options={})
    super options.merge(:except => :deleted_at, :include => {:geocoding => {:only => [], 
      :include => {:geocode => {:only => [:latitude, :longitude]}}}})
  end
end
