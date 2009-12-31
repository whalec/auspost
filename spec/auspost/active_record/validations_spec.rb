require File.join(File.dirname(__FILE__), "../../spec_helper")

describe PostalWorker do
  
  before do 
    PostalWorker.validate_location
    @valid_attributes = {:address => "William St", :suburb => "Annandale", :postcode => "2038", :state => "NSW"}
    @invalid_attributes = {:address => "William St", :suburb => "Annandale", :postcode => "2000", :state => "VIC"}
  end
  
  it "should have a method validate_location" do
    PostalWorker.should respond_to(:validate_location)
  end
  
  it "should not be valid" do
    @worker = PostalWorker.new(@invalid_attributes)
    @worker.should_not be_valid    
  end
  
  it "should validate an address" do
    @worker = PostalWorker.new(@valid_attributes)
    @worker.should be_valid
  end
  
end