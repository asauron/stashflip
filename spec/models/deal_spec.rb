require 'spec_helper'

describe Deal do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Deal.create!(@valid_attributes)
  end
end
