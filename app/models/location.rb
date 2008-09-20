class Location < ActiveRecord::Base
  SIGN_OPTIONS = %w(Blue Red)
  
  acts_as_geocodable :address => {:locality => :city,
	  :region => :state, :postal_code => :zip}, :normalize_address => true
	  
  validates_inclusion_of :signs, :in => SIGN_OPTIONS, :message => 'must be Blue or Red'
end
