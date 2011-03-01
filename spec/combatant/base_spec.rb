require_relative '../spec_helper'

describe GurpsComCal::Combatant do
  context "class methods" do
    subject { GurpsComCal::Combatant }

    describe "yaml" do
      it "should create a new character from the yaml" do
        GurpsComCal::Character.should_receive(:load_yaml).with('path/to/character.yaml')
        subject.load_yaml('path/to/character.yaml')
      end
    end
  end

  context "instance methods" do
    before(:each) do
      @character = double()
      @combatant = GurpsComCal::Combatant.new(@character)
    end

    describe "proxying the character" do
      it "should call character methods on the related character" do
        @character.should_receive :st
        @combatant.st
      end

      it "should NOT pass methods to the character that it won't resspond to" do
        @character.stub(:respond_to?).with(:foo) { false }
        @character.should_not_receive :foo
        expect{@combatant.foo}.to raise_error(NoMethodError)
      end
    end

    describe "damage" do
      before(:each) do
        @character.stub(:hp) { 10 }
      end

      it "should compare injury to the character's HP to report current HP" do
        @combatant.damage(:cr, 1)
        @combatant.current_hp.should == 9
      end

      it "should apply the wounding modifier to penetrating damage" do
        @combatant.damage(:imp, 2)
        @combatant.current_hp.should == 6
      end

      it "should track injury over sucessive calls" do
        @combatant.damage(:cr, 3)
        @combatant.damage(:cr, 2)
        @combatant.current_hp.should == 5
      end

      it "should NOT do fractions" do
        @combatant.damage(:cut, 1)
        @combatant.current_hp.should == 8
      end
    end
  end
end
