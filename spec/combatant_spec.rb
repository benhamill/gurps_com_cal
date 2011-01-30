require 'gurps_com_cal/combatant'

describe GurpsComCal::Combatant do
  describe "proxying the character" do
    before(:each) do
      @character = double()
      @combatant = GurpsComCal::Combatant.new(@character)
    end

    it "should call character methods on the related character" do
      @character.should_receive :st
      @combatant.st
    end

    it "should raise an exception when the related character doesn't have the method" do
      @character.stub(:foo) { raise NoMethodError }
      expect{@combatant.foo}.to raise_error(NoMethodError)
    end
  end
end
