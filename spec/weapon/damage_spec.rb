require_relative '../spec_helper'

describe "GurpsComCal::Weapon::Damage" do
  context "class methods" do
    subject { GurpsComCal::Weapon::Damage }

    describe "new" do
      before(:each) do
        @attack = double
      end

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
end
