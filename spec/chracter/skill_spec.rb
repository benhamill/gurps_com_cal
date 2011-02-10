require_relative '../spec_helper.rb'
require 'gurps_com_cal/character/skill'

describe GurpsComCal::Character::Skill do
  context "class methods" do
    subject { GurpsComCal::Character::Skill }

    describe "initialize" do
      it "should take an attribute with no modifier" do
        s = subject.new(double, "Fightin'", 'DX')
        s.instance_variable_get('@attribute').should == 'DX'
        s.instance_variable_get('@modifier').should == 0
      end

      it "should take an attribute and a modifier" do
        s = subject.new(double, "Fightin'", 'DX', 3)
        s.instance_variable_get('@attribute').should == 'DX'
        s.instance_variable_get('@modifier').should == 3
      end

      it "should parse the attribute and modifier from a string" do
        s = subject.new(double, "Fightin'", 'DX-2')
        s.instance_variable_get('@attribute').should == 'DX'
        s.instance_variable_get('@modifier').should == -2
      end
    end
  end
end
