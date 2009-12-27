require File.join(File.dirname(__FILE__), "../spec_helper")
include Auspost

describe Postie do
  include Postie
  
  it "should find Annandale and return true" do
    check_location_exists({:postcode => "2038", :suburb => "Annandale", :state => "NSW"}).should eql(true)
  end
  
  it "shouldn't find that Surry Hills is in the 2000 postcode" do
    check_location_exists({:postcode => "2000", :suburb => "Surry Hills", :state => "QLD"}).should_not eql(true)
  end
  
end

describe Postie, " with memcached" do
  include Postie
  before do
    @io = mock(IO)
    @string = mock(String)
    Postie::Cache.should_receive(:new).and_return(@io)
    @io.should_receive(:read).with("2038").and_return(@string)
    @string.should_receive(:include?).at_least(:once).and_return(true)
  end
  
  it "should cache a result" do
    check_location_exists({:postcode => "2038", :suburb => "Annandale", :state => "NSW"}).should eql(true)
  end  
end
