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

    context "secondary attributes" do
      describe "basic lift" do
        it "should default to ST squared divided by five" do
          subject.st = 10
          subject.bl.should == 20

          subject.st = 12
          subject.bl.should == 28.8
        end

        it "should retain a value independant of ST when set" do
          subject.bl = 1
          subject.st = 12
          subject.bl.should == 1
        end
      end

      describe "hit points" do
        it "should default to ST" do
          subject.st = 11
          subject.hp.should == 11

          subject.st = 400
          subject.hp.should == 400
        end

        it "should retain a value different from ST when set" do
          subject.hp = 10
          subject.st = 11
          subject.hp.should == 10
        end
      end

      describe "will" do
        it "should default to IQ" do
          subject.iq = 9
          subject.will.should == 9

          subject.iq = 14
          subject.will.should == 14
        end

        it "should retain a value different from IQ when set" do
          subject.will = 9
          subject.iq = 14
          subject.will.should == 9
        end
      end

      describe "perception" do
        it "should default to IQ" do
          subject.iq = 9
          subject.per.should == 9

          subject.iq = 14
          subject.per.should == 14
        end

        it "should retain a value different from IQ when set" do
          subject.per = 9
          subject.iq = 14
          subject.per.should == 9
        end
      end

      describe "fatigue points" do
        it "should default to HT" do
          subject.ht = 10
          subject.fp.should == 10

          subject.ht = 8
          subject.fp.should == 8
        end

        it "should retain a value different from HT when set" do
          subject.fp = 10
          subject.ht = 8
          subject.fp.should == 10
        end
      end
    end

    context "movement" do
      describe "basic speed" do
        it "should default to HT + DX divided by 4" do
          subject.ht = 12
          subject.dx = 8
          subject.basic_speed.should == 5.0
        end

        it "should compute fractions" do
          subject.ht = 12
          subject.dx = 9
          subject.basic_speed.should == 5.25
        end

        it "should retain a value independant of HT and DX when set" do
          subject.basic_speed = 6.25
          subject.dx = 2
          subject.ht = 6
          subject.basic_speed.should == 6.25
        end
      end

      describe "basic move" do
        it "should default to basic speed without fractions" do
          subject.basic_speed = 5.0
          subject.basic_move.should == 5

          subject.basic_speed = 6.25
          subject.basic_move.should == 6
        end

        it "should retain a value independant of basic speed when set" do
          subject.basic_move = 3
          subject.basic_speed = 8.75
          subject.basic_move.should == 3
        end
      end

      describe "dodge" do
        it "should default to basic speed plus three without fractions" do
          subject.basic_speed = 5.0
          subject.dodge.should == 8

          subject.basic_speed = 6.5
          subject.dodge.should == 9
        end

        it "should retain a value independant of basic speed when set" do
          subject.dodge = 10
          subject.basic_speed = 5.0
          subject.dodge.should == 10
        end
      end
    end
  end
end
