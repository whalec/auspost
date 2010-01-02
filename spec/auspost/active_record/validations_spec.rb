require File.join(File.dirname(__FILE__), "../../spec_helper")
require File.join(File.dirname(__FILE__), "../../fixtures/postal_worker")

describe PostalWorker, "without auspost/active_record required" do
  
  it "should not respond to a method validate_location" do
    PostalWorker.should_not respond_to(:validate_location)
  end
  
end


describe PostalWorker, "with auspost/active_record required" do

  # require needs to be in the before block, otherwise it's called when the file is required or the describe blocks are called.
  # causing failure to the above spec
  before(:all) do
    require 'auspost/active_record'
    PostalWorker.validate_location
  end

  before do
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
    @worker = PostalWorker.new({:suburb => "Rozelle", :postcode => "2039", :state => "NSW"})
    @worker.should be_valid
  end
  
  it "should return a useful error message on the state" do
    @worker = PostalWorker.new(@invalid_attributes)
    @worker.should_not be_valid
    @worker.errors.on(:state).should eql("VIC is not found in the 2000 postcode")
    @worker.errors.on(:suburb).should eql("ANNANDALE is not found in the 2000 postcode")
  end
  
  it "should return a useful error message on the suburb" do
    @worker = PostalWorker.new(@valid_attributes.merge(:suburb => "Rozelle"))
    @worker.should_not be_valid
    @worker.errors.on(:suburb).should eql("ROZELLE is not found in the 2038 postcode")
    @worker.errors.on(:state).should be_nil
  end
end


describe MashedPostalWorker, "with options set on the validation" do
  before(:all) do
    require 'auspost/active_record'
    MashedPostalWorker.validate_location  :suburb => {:accessor => :city, :message => "That doesn't match up!"},
                                          :postcode => {:accessor => :zipcode, :message => ["Postcode %s cannot be found", :zipcode]},
                                          :state => {:accessor => "state.name", :message => ["%s is such a better state anyway *ducks*", "state.name"]}
  end
  
  it "should have a custom message on the suburb" do
    @worker = MashedPostalWorker.new({:city => "Annandale", :zipcode => 3001, :state => State.new(:name => "NSW")})
    @worker.should_not be_valid
    @worker.errors.on(:suburb).should eql("That doesn't match up!")
    @worker.errors.on(:state).should eql("NSW is such a better state anyway *ducks*")
  end
  
end