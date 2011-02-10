require_relative '../spec_helper'

class AttributesHolder
  include GurpsComCal::Character::Attributes
end

describe "GurpsComCal::Character::Attributes" do
  subject { AttributesHolder.new }

  context "Basic Attributes" do
    it "should all default to 10" do
      subject.st.should == 10
      subject.dx.should == 10
      subject.iq.should == 10
      subject.ht.should == 10
    end

    it "should all return a stored value if set" do
      subject.st = 11
      subject.st.should == 11

      subject.dx = 11
      subject.dx.should == 11

      subject.iq = 11
      subject.iq.should == 11

      subject.ht = 11
      subject.ht.should == 11
    end
  end
end
