require_relative 'spec_helper'

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

  describe "equality" do
    it "should compare two rolls by value" do
      GurpsComCal::Roll.new(1, 3).should == GurpsComCal::Roll.new(1, 3)
    end

    it "should fail out objects that don't behave like Rolls" do
      GurpsComCal::Roll.new(1, 3).should_not == 3
    end
  end

  describe "addition" do
    it "should add two rolls together" do
      result = GurpsComCal::Roll.new(1,3) + GurpsComCal::Roll.new(2)

      result.should == GurpsComCal::Roll.new(3, 3)
    end

    it "should add a roll and an integer" do
      result = GurpsComCal::Roll.new(1, 3) + 2

      result.should == GurpsComCal::Roll.new(1, 5)
    end
  end

  describe "subtraction" do
    it "should subtract two rolls" do
      result = GurpsComCal::Roll.new(2,3) - GurpsComCal::Roll.new(1, 1)

      result.should == GurpsComCal::Roll.new(1,2)
    end

    it "should subtract an integer from a roll" do
      result = GurpsComCal::Roll.new(2,3) - 2

      result.should == GurpsComCal::Roll.new(2,1)
    end
  end

  describe "result" do
    it "should roll a d6 for each dice in the roll" do
      GurpsComCal::Roll.should_receive(:rand).with(6).exactly(5).times.and_return(0)
      GurpsComCal::Roll.result(GurpsComCal::Roll.new("5d")).should == 5
    end

    it "should add anything in the adds to the result" do
      GurpsComCal::Roll.should_receive(:rand).exactly(3).times.and_return(0)
      GurpsComCal::Roll.result(GurpsComCal::Roll.new("3d+2")).should == 5
    end

    it "should default to rolling 3d" do
      GurpsComCal::Roll.should_receive(:rand).exactly(3).times.and_return(0)
      GurpsComCal::Roll.result.should == 3
    end

    it "should proxy the class method on an instance" do
      roll = GurpsComCal::Roll.new('2d-1')
      GurpsComCal::Roll.should_receive(:result).with(roll).and_return(10)
      roll.result.should == 10
    end

    it "should NOT return a < 0 result" do
      GurpsComCal::Roll.should_receive(:rand).exactly(3).times.and_return(0)
      GurpsComCal::Roll.result(GurpsComCal::Roll.new("3d-10")).should == 0
    end

    it "should try to create a Roll object if the arg wansn't one" do
      roll = GurpsComCal::Roll.new('3d')
      GurpsComCal::Roll.should_receive(:new).with('3d').and_return(roll)
      GurpsComCal::Roll.result
    end
  end
end
