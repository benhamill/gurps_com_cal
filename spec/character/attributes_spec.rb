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

  context "Secondary Characteristics" do
    describe "damage" do
      before(:all) do
        subject.st = 12
      end

      describe "thrust" do
        it "should default to the appropriate thurst value for ST on the Damage Table" do
          GurpsComCal::Character::Attributes::DAMAGE_TABLE.should_receive('[]').with(12).and_return({ :thr => '1d-1' })
          subject.thrust.should == '1d-1'
        end

        it "should store a value if set" do
          subject.thrust = 'foobar'
          subject.thrust.should == 'foobar'
        end

        it "should should be aliased as thr" do
          subject.should_receive(:thrust)
          subject.thr
        end
      end

      describe "swing" do
        it "should default to the appropriate thurst value for ST on the Damage Table" do
          GurpsComCal::Character::Attributes::DAMAGE_TABLE.should_receive('[]').with(12).and_return({ :sw => '1d+2' })
          subject.swing.should == '1d+2'
        end

        it "should store a value if set" do
          subject.swing = 'foobar'
          subject.swing.should == 'foobar'
        end

        it "should should be aliased as sw" do
          subject.should_receive(:swing)
          subject.sw
        end
      end
    end
  end
end
