require "mongoid/spec_helper"

describe Mongoid::Fields do

  let(:address) do
    Address.new        
  end
  
  let(:point) do
    b = (Struct.new :lat, :lng).new
    b.lat = 72
    b.lng = -44
    b
  end  

  describe "Special geo Array setter" do
    it "should split a String into parts and convert to floats" do
      address.location = "23.5, -47"
      address.location.should == [23.5, -47]
    end

    it "should convert Strings into floats" do
      address.location = "23.5", "-48"
      address.location.should == [23.5, -48]
    end

    it "should work with point Hash, keys :lat, :lng" do
      address.location = {:lat => 23.5, :lng => -49}
      address.location.should == [23.5, -49]
    end

    it "should work with point Hash, keys :latitude, :longitude" do
      address.location = {:latitude => 23.5, :longitude => -49}
      address.location.should == [23.5, -49]
    end


    it "should work with point hashes using the first point only" do
      address.location = [{:lat => 23.5, :lng => -49}, {:lat => 72, :lng => -49}]
      address.location.should == [23.5, -49]
    end

    it "should work with point object" do
      address.location = point
      address.location.should == [72, -44]
    end

    it "should work with point objects using the first point only" do
      address.location = [point, {:lat => 72, :lng => -49}]
      address.location.should == [72, -44]
    end

    it "should drop nils" do
      address.location = [nil, point, {:lat => 72, :lng => -49}]
      address.location.should == [72, -44]
    end

    it "should default to normal behavior" do
      address.location = 23.5, -49
      address.location.should == [23.5, -49]

      address.location = [23.5, -50]
      address.location.should == [23.5, -50]
    end
    
    it "should handle nil values" do
      address.location = nil
      address.location.should be_nil
    end
  end
end