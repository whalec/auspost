require File.join(File.dirname(__FILE__), "spec_helper")

describe Auspost do
  
  it "should be a module" do
    Auspost.class.should eql(Module)
  end
  
end
