require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do
  describe "#new_from_email" do
    it "should be subject" do
      location = Location.new_from_email(email_fixture(:red_no_subject))
      location.valid?
      location.errors.on(:signs).should_not be_blank
    end
    
    it "should require body" do
      location = Location.new_from_email(email_fixture(:red_no_body))
      location.valid?
      location.errors.full_messages.should include("We can't find a precise enough address match.")
    end
    
    it "should set street to email body" do
      location = Location.new_from_email(email_fixture(:red))
      location.street.should == '1600 Pennsylvania Ave. Washington, D.C.'
    end
    
    it "should set sign equal to subject" do
      location = Location.new_from_email(email_fixture(:red))
      location.signs.should == 'Red'
    end
    
    it "should work with mixed case subject" do
      location = Location.new_from_email(email_fixture(:red_mixedcase_subject))
      location.signs.should == 'Red'
    end
    
    it "should work with upper case subject" do
      location = Location.new_from_email(email_fixture(:red_uppercase_subject))
      location.signs.should == 'Red'
    end
    
    it "should work with multi line body" do
      location = Location.new_from_email(email_fixture(:red_address_two_lines))
      location.valid?
      location.to_location.to_s.should == "1600 Pennsylvania Ave Nw\nWashington, DC 20006"
    end
    
    it "should work with multi line body and email signature" do
      location = Location.new_from_email(email_fixture(:red_address_two_lines_sig))
      location.valid?
      location.to_location.to_s.should == "1600 Pennsylvania Ave Nw\nWashington, DC 20006"
    end
  end
end
