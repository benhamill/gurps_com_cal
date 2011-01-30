require 'gurps_com_cal/combatant'

describe GurpsComCal::Combatant do
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
      @character.should_not_receive :foo
      @combatant.foo
    end

    it "should raise an exception when the related character doesn't have the method" do
      expect{@combatant.foo}.to raise_error(NoMethodError)
    end
  end

  describe "damage" do
    before(:each) do
      @character.stub(:hp) { 10 }
    end

    it "should compare damage taken to @character's HP to report current HP" do
      @combatant.damage(:cr, 1)
      @combatant.current_hp.should == 9
    end

    it "should multiply damage based on type" do
      @combatant.damage(:imp, 2)
      @combatant.current_hp.should == 6
    end
  end
end
