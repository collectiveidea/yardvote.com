class Location < ActiveRecord::Base
  SIGN_OPTIONS = %w(Blue Red Purple)
  
  acts_as_geocodable :address => {:street => :street, :locality => :city,
	  :region => :state, :postal_code => :zip}, :normalize_address => true
	
	acts_as_paranoid
	  
  validates_inclusion_of :signs, :in => SIGN_OPTIONS, :message => 'must be Blue, Red or Purple'
  
end
