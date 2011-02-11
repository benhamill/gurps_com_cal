require_relative '../spec_helper'

describe "GurpsComCal::Weapon::Damage" do
  before(:each) do
    @attack = double
  end

  context "class methods" do
    subject { GurpsComCal::Weapon::Damage }

    describe "new" do
      it "should accept an attack, a Roll and a type" do
        roll = double
        roll.stub(:kind_of?).with(GurpsComCal::Roll) { true }

        s = subject.new(@attack, roll, 'cut')

        s.instance_variable_get('@type').should == 'cut'
        s.instance_variable_get('@roll').should == roll
        s.instance_variable_get('@attack').should == @attack
      end

      it "should handle rolls as a string describing dice" do
        GurpsComCal::Roll.should_receive(:new).with('1d+2')
        subject.new(@attack, '1d+2', 'cut')
      end

      it "should handle rolls as a string describing a character stat" do
        s = subject.new(@attack, 'thr+2', 'cut')
        s.instance_variable_get('@damage_base').should == 'thr'
        s.instance_variable_get('@damage_mod').should == 2
      end

      it "should parse damage roll and type from a string" do
        s = subject.new(@attack, 'sw-2 cr')
        s.instance_variable_get('@damage_base').should == 'sw'
        s.instance_variable_get('@damage_mod').should == -2
        s.instance_variable_get('@type').should == 'cr'
      end
    end
  end

  context "instance methods" do
    describe "inspect" do
      it "should return a string, because, really, I don't care" do
        GurpsComCal::Weapon::Damage.new(@attack, "thr-1 pi+").inspect.should be_a(String)
      end
    end

    context "with pure-dice damage" do
      subject { GurpsComCal::Weapon::Damage.new(@attack, '1d+2', 'pi') }

      before(:each) do
        @roll = double
        GurpsComCal::Roll.stub(:new).with('1d+2') { @roll }
        @roll.stub(:to_s) { '1d+2' }
      end

      describe "roll" do
        it "should just pass along the dice of the damage" do
          subject.roll.should == @roll
        end
      end

      describe "to_s" do
        it "should display the damage and the type" do
          subject.to_s.should == '1d+2 pi'
        end
      end
    end

    context "with stat-based damage" do
      subject { GurpsComCal::Weapon::Damage.new(@attack, 'thr-1', 'pi+') }

      describe "roll" do
        it "should get a roll object for the stat from the attack's character" do
          char = double
          char.should_receive(:thr) { double(:+ => '1d+2') }
          @attack.should_receive(:character) { char }
          subject.roll
        end

        it "should add the damage modifier to the character's stat-based roll" do
          roll = double
          @attack.stub_chain('character.thr') { roll }
          roll.should_receive('+').with(-1) { '1d+2' }
          subject.roll.should == '1d+2'
        end
      end

      describe "to_s" do
        it "should compute a stat-and-modifier string to return with the type" do
          subject.to_s.should == 'thr-1 pi+'
        end
      end
    end
  end
end
