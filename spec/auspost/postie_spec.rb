require File.join(File.dirname(__FILE__), "../spec_helper")
include Auspost

describe Postie do
  include Postie
  
  it "should find Annandale and return true" do
    location?({:postcode => "2038", :suburb => "Annandale", :state => "NSW"}).should eql(true)
  end
  
  it "shouldn't find that Surry Hills is in the 2000 postcode" do
    location?({:postcode => "2000", :suburb => "Surry Hills", :state => "QLD"}).should_not eql(true)
  end
  
  # Testing this to ensure sub-strings don't pass as true
  it "shoudn't find dale in 2038" do
    location?({:postcode => "2038", :suburb => "dale", :state => "NSW"}).should_not eql(true)
  end
  
  it "shouldn't substring search" do
    location?(:postcode => "2038", :suburb => "Annandale", :state => "N")
  end
  
  it "should raise if there's not a postcode" do
    lambda { location?(:suburb => "Surry Hills", :state => "FOO") }.should raise_error(ArgumentError)
  end
  
  it "should raise if there's not a suburb" do
    lambda { location?(:postcode => 2038, :state => "FOO") }.should raise_error(ArgumentError)
  end
  
  it "should raise if there's not a state" do
    lambda { location?(:suburb => "Surry Hills", :postcode => 2038) }.should raise_error(ArgumentError)
  end
  
  it "should accept an Integer for the postcode" do
    location?({:postcode => 2038, :suburb => "Annandale", :state => "NSW"}).should eql(true)
  end
  
end

describe Postie, " with cached" do
  include Postie
  before do
    @io = mock(IO)
    @string = mock(String)
    @array  = mock(Array)
    Postie::Cache.should_receive(:new).and_return(@io)
    @io.should_receive(:read).with("2038").and_return(@string)
    @string.should_receive(:map).at_least(:once).and_return(@array)
    @array.should_receive(:include?).with(true).and_return(true)
  end
  
  it "should cache a result" do
    location?({:postcode => "2038", :suburb => "Annandale", :state => "NSW"}).should eql(true)
  end  
end
