require_relative '../spec_helper'

class DefenseHolder
  include GurpsComCal::Combatant::Defense
end

describe "GurpsComCal::Combatant::Defense" do
  before(:each) do
    @weapon = double(GurpsComCal::Weapon)
    @weapon.stub(:respond_to).with(:parry) { false }
    subject.stub(:equipped_weapon) { @weapon }
  end

  subject { DefenseHolder.new }

  describe "#defenses" do
    context "with an equipped melee weapon that can parry" do
      before(:each) do
        @weapon.stub(:respond_to).with(:parry) { true }
      end

      it "should list parry" do
        subject.defenses.should include('parry')
      end
    end

    context "without an equipped weapon that can parry" do
      it "should NOT list parry" do
        subject.defenses.should_not include('parry')
      end
    end

    context "when the combatant can dodge" do
      it "should list dodge" do
        subject.defenses.should include('dodge')
      end
    end
  end
end
