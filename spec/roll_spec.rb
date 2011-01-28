require 'gurps_com_cal/roll'

describe GurpsComCal::Roll do
  describe "initialize" do
    it "should build a GurpsComCal::Roll from two integers" do
      roll = GurpsComCal::Roll.new 1, 3

      roll.dice.should == 1
      roll.adds.should == 3
    end

    it "should build a roll from a nd+n string" do
      roll = GurpsComCal::Roll.new "1d+3"

      roll.dice.should == 1
      roll.adds.should == 3
    end

    it "should build a roll with no adds" do
      roll = GurpsComCal::Roll.new 2

      roll.dice.should == 2
      roll.adds.should == 0
    end
  end

  describe "to_s" do
    it "should handle negative adds" do
      GurpsComCal::Roll.new(1, -3).to_s.should == '1d-3'
    end

    it "should handle positive adds" do
      GurpsComCal::Roll.new(1, 3).to_s.should == '1d+3'
    end

    it "should handle no adds" do
      GurpsComCal::Roll.new(2).to_s.should == '2d'
    end
  end
end
