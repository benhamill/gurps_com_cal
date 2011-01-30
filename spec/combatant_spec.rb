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
  end
end
